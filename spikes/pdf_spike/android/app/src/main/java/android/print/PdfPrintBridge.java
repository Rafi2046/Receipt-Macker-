package android.print;

import android.os.CancellationSignal;
import android.os.ParcelFileDescriptor;

import java.io.File;

/**
 * Lives in android.print to reach the package-private callback constructors
 * (same technique the printing plugin uses). Spike only.
 */
public final class PdfPrintBridge {
    public interface Callback {
        void onDone(File file, int pages);
        void onFailed(String message);
    }

    public static void write(PrintDocumentAdapter adapter, PrintAttributes attributes, File out, Callback cb) {
        adapter.onLayout(null, attributes, null, new PrintDocumentAdapter.LayoutResultCallback() {
            @Override
            public void onLayoutFinished(PrintDocumentInfo info, boolean changed) {
                try {
                    ParcelFileDescriptor fd = ParcelFileDescriptor.open(out,
                            ParcelFileDescriptor.MODE_READ_WRITE | ParcelFileDescriptor.MODE_CREATE | ParcelFileDescriptor.MODE_TRUNCATE);
                    adapter.onWrite(new PageRange[] {PageRange.ALL_PAGES}, fd, new CancellationSignal(),
                            new PrintDocumentAdapter.WriteResultCallback() {
                                @Override
                                public void onWriteFinished(PageRange[] pages) {
                                    try { fd.close(); } catch (Exception ignored) { }
                                    cb.onDone(out, info.getPageCount());
                                }

                                @Override
                                public void onWriteFailed(CharSequence error) {
                                    cb.onFailed("write failed: " + error);
                                }
                            });
                } catch (Exception e) {
                    cb.onFailed("open failed: " + e);
                }
            }

            @Override
            public void onLayoutFailed(CharSequence error) {
                cb.onFailed("layout failed: " + error);
            }
        }, null);
    }
}
