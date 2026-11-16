package com.rafi.quickbill

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.provider.ContactsContract
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Opens the system contact picker. Uses [Activity.startActivityForResult]
 * because Activity Result API cannot be registered from [configureFlutterEngine].
 */
class ContactPickerChannel(
    private val activity: Activity,
    messenger: BinaryMessenger,
) {
    private val channel = MethodChannel(messenger, NAME)
    private var pending: MethodChannel.Result? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickContact" -> launchPicker(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun launchPicker(result: MethodChannel.Result) {
        if (pending != null) {
            result.error("busy", "a contact pick is already open", null)
            return
        }
        val intent = pickIntent()
        if (intent == null) {
            Log.e(TAG, "No activity can handle contact pick")
            result.error("unavailable", "no_contacts_app", null)
            return
        }
        pending = result
        try {
            @Suppress("DEPRECATION")
            activity.startActivityForResult(intent, REQUEST)
        } catch (e: ActivityNotFoundException) {
            pending = null
            Log.e(TAG, "startActivityForResult failed", e)
            result.error("unavailable", "no_contacts_app", null)
        } catch (e: Exception) {
            pending = null
            Log.e(TAG, "startActivityForResult failed", e)
            result.error("contacts", e.message, null)
        }
    }

    /** Prefer phone picker; fall back to full contact picker. */
    private fun pickIntent(): Intent? {
        val phone = Intent(Intent.ACTION_PICK).apply {
            type = ContactsContract.CommonDataKinds.Phone.CONTENT_TYPE
        }
        if (phone.resolveActivity(activity.packageManager) != null) return phone

        val contact = Intent(
            Intent.ACTION_PICK,
            ContactsContract.Contacts.CONTENT_URI,
        )
        if (contact.resolveActivity(activity.packageManager) != null) return contact
        return null
    }

    /** Returns true when this channel handled the result. */
    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST) return false
        val reply = pending ?: return true
        pending = null
        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            reply.success(null)
            return true
        }
        try {
            reply.success(readPickedUri(data.data!!))
        } catch (e: Exception) {
            Log.e(TAG, "Failed reading contact", e)
            reply.error("contacts", e.message, null)
        }
        return true
    }

    private fun readPickedUri(uri: android.net.Uri): Map<String, String?> {
        val mime = activity.contentResolver.getType(uri).orEmpty()
        return if (mime.contains("phone", ignoreCase = true) ||
            uri.toString().contains("phones", ignoreCase = true)
        ) {
            readPhoneUri(uri)
        } else {
            readContactUri(uri)
        }
    }

    private fun readPhoneUri(uri: android.net.Uri): Map<String, String?> {
        val projection = arrayOf(
            ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
            ContactsContract.CommonDataKinds.Phone.NUMBER,
            ContactsContract.CommonDataKinds.Phone.CONTACT_ID,
        )
        activity.contentResolver.query(uri, projection, null, null, null).use { cursor ->
            if (cursor == null || !cursor.moveToFirst()) {
                return emptyContact()
            }
            val name = cursor.getString(0)
            val phone = cursor.getString(1)
            val contactId = cursor.getString(2)
            return mapOf(
                "name" to name,
                "phone" to phone,
                "email" to contactId?.let(::emailForContact),
            )
        }
    }

    private fun readContactUri(uri: android.net.Uri): Map<String, String?> {
        val projection = arrayOf(
            ContactsContract.Contacts._ID,
            ContactsContract.Contacts.DISPLAY_NAME,
            ContactsContract.Contacts.HAS_PHONE_NUMBER,
        )
        activity.contentResolver.query(uri, projection, null, null, null).use { cursor ->
            if (cursor == null || !cursor.moveToFirst()) {
                return emptyContact()
            }
            val id = cursor.getString(0) ?: return emptyContact()
            val name = cursor.getString(1)
            val hasPhone = (cursor.getString(2)?.toIntOrNull() ?: 0) > 0
            val phone = if (hasPhone) phoneForContact(id) else null
            return mapOf(
                "name" to name,
                "phone" to phone,
                "email" to emailForContact(id),
            )
        }
    }

    private fun phoneForContact(contactId: String): String? {
        val projection = arrayOf(ContactsContract.CommonDataKinds.Phone.NUMBER)
        val selection = "${ContactsContract.CommonDataKinds.Phone.CONTACT_ID}=?"
        return try {
            activity.contentResolver.query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                projection,
                selection,
                arrayOf(contactId),
                null,
            ).use { cursor ->
                if (cursor != null && cursor.moveToFirst()) cursor.getString(0) else null
            }
        } catch (_: SecurityException) {
            null
        }
    }

    private fun emailForContact(contactId: String): String? {
        val projection = arrayOf(ContactsContract.CommonDataKinds.Email.ADDRESS)
        val selection = "${ContactsContract.CommonDataKinds.Email.CONTACT_ID}=?"
        return try {
            activity.contentResolver.query(
                ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                projection,
                selection,
                arrayOf(contactId),
                null,
            ).use { cursor ->
                if (cursor != null && cursor.moveToFirst()) cursor.getString(0) else null
            }
        } catch (_: SecurityException) {
            null
        }
    }

    private fun emptyContact() =
        mapOf("name" to null, "phone" to null, "email" to null)

    companion object {
        private const val TAG = "QuickBillContacts"
        const val NAME = "quickbill/contacts"
        const val REQUEST = 9917
    }
}
