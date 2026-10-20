package com.rafi.pdf_spike

import android.print.PdfPrintBridge
import android.print.PrintAttributes
import android.util.Log
import android.view.ViewGroup
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "spike/html2pdf").setMethodCallHandler { call, result ->
            val html = call.argument<String>("html") ?: return@setMethodCallHandler result.error("args", "html missing", null)
            convert(html, { result.success(it) }, { result.error("html2pdf", it, null) })
        }
    }

    /** Renders [html] in an attached, invisible WebView and prints it to an A4 PDF. */
    private fun convert(html: String, ok: (ByteArray) -> Unit, fail: (String) -> Unit) {
        val root = window.decorView as ViewGroup
        val webView = WebView(this).apply { alpha = 0f }
        root.addView(webView, ViewGroup.LayoutParams(1080, 1527))
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView, url: String?) {
                Log.i("html2pdf", "page finished")
                val attrs = PrintAttributes.Builder()
                    .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
                    .setResolution(PrintAttributes.Resolution("pdf", "pdf", 600, 600))
                    .setMinMargins(PrintAttributes.Margins.NO_MARGINS)
                    .build()
                val out = File(cacheDir, "html2pdf.pdf")
                PdfPrintBridge.write(view.createPrintDocumentAdapter("spike"), attrs, out, object : PdfPrintBridge.Callback {
                    override fun onDone(file: File, pages: Int) {
                        Log.i("html2pdf", "done pages=$pages")
                        root.removeView(webView); webView.destroy()
                        ok(file.readBytes())
                    }

                    override fun onFailed(message: String) {
                        Log.e("html2pdf", message)
                        root.removeView(webView); webView.destroy()
                        fail(message)
                    }
                })
            }
        }
        webView.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null)
    }
}
