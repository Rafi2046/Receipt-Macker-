import 'package:url_launcher/url_launcher.dart';

/// Service to handle external URL launching such as phone calls and WhatsApp chats.
abstract final class UrlLaunchService {
  /// Test override for URL launching in widget tests.
  static Future<bool> Function(String url)? urlLauncherOverride;

  /// Opens an external web URL. Returns false if invalid or cannot launch.
  static Future<bool> openUrl(String urlString) async {
    if (urlLauncherOverride != null) {
      return urlLauncherOverride!(urlString);
    }
    final uri = Uri.tryParse(urlString);
    if (uri == null) return false;
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  /// Launches the phone dialer with [phone]. Returns false if invalid or cannot launch.
  static Future<bool> callPhone(String phone) async {
    final sanitized = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    if (sanitized.isEmpty) return false;
    final uri = Uri(scheme: 'tel', path: sanitized);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  /// Opens WhatsApp to chat with [phone]. Returns false if invalid or cannot launch.
  static Future<bool> openWhatsApp(String phone) async {
    // WhatsApp wa.me takes digits only without '+' or spaces.
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return false;
    final uri = Uri.parse('https://wa.me/$digits');
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}
