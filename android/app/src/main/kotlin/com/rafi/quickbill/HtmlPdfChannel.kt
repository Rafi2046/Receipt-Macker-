package com.rafi.quickbill

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.print.PdfPrintBridge
import android.print.PrintAttributes
import android.print.PrintManager
import android.view.ViewGroup
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Renders HTML in an attached, invisible WebView and prints it to a PDF
 * file (htmlToPdf), or opens the system print dialog (printHtml) as a
 * fallback. One job at a time; Dart waits for each result.
 */
class HtmlPdfChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, NAME)
    private val main = Handler(Looper.getMainLooper())
    private var busy = false

    init {
        channel.setMethodCallHandler(::onCall)
    }

    private fun onCall(call: MethodCall, result: MethodChannel.Result) {
        val html = call.argument<String>("html")
            ?: return result.error("args", "html missing", null)
        when (call.method) {
            "htmlToPdf" -> {
                val path = call.argument<String>("path")
                    ?: return result.error("args", "path missing", null)
                if (busy) return result.error("busy", "a PDF is already being made", null)
                busy = true
                load(html) { view, done ->
                    toPdf(view, File(path), call.argument<String>("pageSize")) { pages, error ->
                        done()
                        busy = false
                        if (error == null) result.success(pages) else result.error("pdf", error, null)
                    }
                }
            }
            "printHtml" -> load(html) { view, _ ->
                val jobName = call.argument<String>("jobName") ?: "QuickBill"
                val manager = activity.getSystemService(Context.PRINT_SERVICE) as PrintManager
                // The WebView stays attached until the print job has its copy.
                manager.print(jobName, view.createPrintDocumentAdapter(jobName), attributes(null))
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    /** Loads [html], waits for fonts, then calls [ready]; call done() to remove the view. */
    private fun load(html: String, ready: (WebView, () -> Unit) -> Unit) {
        val root = activity.window.decorView as ViewGroup
        val view = WebView(activity).apply {
            alpha = 0f
            // The PDF must not grow with the phone's font size setting.
            settings.textZoom = TEXT_ZOOM_NORMAL
        }
        root.addView(view, ViewGroup.LayoutParams(LAYOUT_WIDTH, LAYOUT_HEIGHT))
        val done = {
            root.removeView(view)
            view.destroy()
        }
        var started = false
        val timeout = Runnable {
            if (!started) {
                started = true
                ready(view, done)
            }
        }
        view.webViewClient = object : WebViewClient() {
            override fun onPageFinished(webView: WebView, url: String?) {
                waitForFonts(webView, FONT_CHECKS) {
                    if (!started) {
                        started = true
                        main.removeCallbacks(timeout)
                        ready(webView, done)
                    }
                }
            }
        }
        main.postDelayed(timeout, LOAD_TIMEOUT_MS)
        view.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null)
    }

    private fun waitForFonts(view: WebView, checksLeft: Int, then: () -> Unit) {
        view.evaluateJavascript("document.fonts.status") { status ->
            if (status.contains("loaded") || checksLeft <= 0) {
                then()
            } else {
                main.postDelayed({ waitForFonts(view, checksLeft - 1, then) }, FONT_CHECK_MS)
            }
        }
    }

    private fun toPdf(view: WebView, out: File, pageSize: String?, finish: (Int, String?) -> Unit) {
        out.parentFile?.mkdirs()
        PdfPrintBridge.write(
            view.createPrintDocumentAdapter(out.name),
            attributes(pageSize),
            out,
            object : PdfPrintBridge.Callback {
                override fun onDone(pageCount: Int) = finish(pageCount, null)
                override fun onFailed(message: String) = finish(0, message)
            },
        )
    }

    private fun attributes(pageSize: String?): PrintAttributes =
        PrintAttributes.Builder()
            .setMediaSize(
                if (pageSize == "letter") PrintAttributes.MediaSize.NA_LETTER
                else PrintAttributes.MediaSize.ISO_A4,
            )
            .setResolution(PrintAttributes.Resolution("pdf", "pdf", DPI, DPI))
            // Page margins come from the CSS @page rule.
            .setMinMargins(PrintAttributes.Margins.NO_MARGINS)
            .build()

    companion object {
        const val NAME = "quickbill/html_pdf"
        private const val LAYOUT_WIDTH = 1080
        private const val LAYOUT_HEIGHT = 1527
        private const val DPI = 600
        private const val TEXT_ZOOM_NORMAL = 100
        private const val LOAD_TIMEOUT_MS = 30_000L
        private const val FONT_CHECKS = 30
        private const val FONT_CHECK_MS = 100L
    }
}
