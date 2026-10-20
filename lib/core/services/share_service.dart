import 'package:share_plus/share_plus.dart';

/// Opens the Android share sheet (WhatsApp, email, Drive…).
class ShareService {
  /// Shares the file at [path]. Returns true unless the user dismissed the
  /// sheet (Android does not always report the choice; unknown counts as
  /// shared).
  Future<bool> shareFile(
    String path, {
    required String mimeType,
    String? subject,
    String? text,
  }) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path, mimeType: mimeType)],
        subject: subject,
        text: text,
      ),
    );
    return result.status != ShareResultStatus.dismissed;
  }
}
