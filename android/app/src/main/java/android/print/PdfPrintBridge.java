package android.print;

import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;

import java.io.File;

/**
 * Writes a {@link PrintDocumentAdapter} (from a WebView) straight to a PDF
 * file, without the system print dialog.
 *
 * <p>Lives in the {@code android.print} package because the layout and write
 * callback constructors are package-private (the technique the printing
 * plugin has used for years). Tested on Android 14; if a future Android
 * blocks it, the app falls back to the system print dialog
 * ({@code printHtml}).
 */
public final class PdfPrintBridge {
    private PdfPrintBridge() { }

    public interface Callback {
        void onDone(int pageCount);

        void onFailed(String message);
    }

    public static void write(
            PrintDocumentAdapter adapter,
            PrintAttributes attributes,
            File out,
            Callback callback) {
        adapter.onLayout(null, attributes, null, new PrintDocumentAdapter.LayoutResultCallback() {
            @Override
            public void onLayoutFinished(PrintDocumentInfo info, boolean changed) {
                writePages(adapter, info, out, callback);
            }

            @Override
            public void onLayoutFailed(CharSequence error) {
                callback.onFailed("layout failed: " + error);
            }
        }, null);
    }

    private static void writePages(
            PrintDocumentAdapter adapter,
            PrintDocumentInfo info,
            File out,
            Callback callback) {
        final ParcelFileDescriptor fd;
        try {
            fd = ParcelFileDescriptor.open(out,
                    ParcelFileDescriptor.MODE_READ_WRITE
                            | ParcelFileDescriptor.MODE_CREATE
                            | ParcelFileDescriptor.MODE_TRUNCATE);
        } catch (Exception e) {
            callback.onFailed("open failed: " + e);
            return;
        }
        adapter.onWrite(new PageRange[] {PageRange.ALL_PAGES}, fd, new CancellationSignal(),
                new PrintDocumentAdapter.WriteResultCallback() {
                    @Override
                    public void onWriteFinished(PageRange[] pages) {
                        close(fd);
                        callback.onDone(info.getPageCount());
                    }

                    @Override
                    public void onWriteFailed(CharSequence error) {
                        close(fd);
                        callback.onFailed("write failed: " + error);
                    }
                });
    }

    private static void close(ParcelFileDescriptor fd) {
        try {
            fd.close();
        } catch (Exception ignored) {
            // Nothing useful to do; the file is already written or failed.
        }
    }
}
