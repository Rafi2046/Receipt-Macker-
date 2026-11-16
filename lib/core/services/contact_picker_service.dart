import 'package:flutter/services.dart';

/// One contact chosen from the device address book.
typedef PickedContact = ({String name, String phone, String email});

/// Opens the system contact picker via our Android bridge
/// (`ContactPickerChannel.kt`). Returns null when the user cancels.
class ContactPickerService {
  ContactPickerService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  static const String channelName = 'quickbill/contacts';

  final MethodChannel _channel;

  /// Null = user cancelled. Throws [MissingPluginException] / [PlatformException]
  /// when the native picker is unavailable or fails.
  Future<PickedContact?> pickContact() async {
    final raw = await _channel.invokeMethod<dynamic>('pickContact');
    if (raw is! Map) return null;
    final name = (raw['name'] as String?)?.trim() ?? '';
    final phone = (raw['phone'] as String?)?.trim() ?? '';
    final email = (raw['email'] as String?)?.trim() ?? '';
    if (name.isEmpty && phone.isEmpty && email.isEmpty) return null;
    return (name: name, phone: phone, email: email);
  }
}
