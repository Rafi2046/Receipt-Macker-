/// Currencies offered in pickers, most likely first for the launch audience.
/// Any ISO 4217 code works in formatting; a searchable full list comes in M7.
abstract final class AppCurrencies {
  static const List<String> common = [
    'BDT',
    'INR',
    'PKR',
    'NPR',
    'LKR',
    'USD',
    'EUR',
    'GBP',
    'AED',
    'SAR',
    'QAR',
    'KWD',
    'OMR',
    'MYR',
    'SGD',
    'AUD',
    'CAD',
    'JPY',
    'CNY',
  ];

  /// Flag emoji for the country most associated with [code].
  static String flag(String code) => _flags[code] ?? '🏳️';

  /// English display name. UI language for names can wait for M7.
  static String name(String code) => _names[code] ?? code;

  static const Map<String, String> _flags = {
    'BDT': '🇧🇩',
    'INR': '🇮🇳',
    'PKR': '🇵🇰',
    'NPR': '🇳🇵',
    'LKR': '🇱🇰',
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'AED': '🇦🇪',
    'SAR': '🇸🇦',
    'QAR': '🇶🇦',
    'KWD': '🇰🇼',
    'OMR': '🇴🇲',
    'MYR': '🇲🇾',
    'SGD': '🇸🇬',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'JPY': '🇯🇵',
    'CNY': '🇨🇳',
  };

  static const Map<String, String> _names = {
    'BDT': 'Bangladeshi Taka',
    'INR': 'Indian Rupee',
    'PKR': 'Pakistani Rupee',
    'NPR': 'Nepalese Rupee',
    'LKR': 'Sri Lankan Rupee',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'QAR': 'Qatari Riyal',
    'KWD': 'Kuwaiti Dinar',
    'OMR': 'Omani Rial',
    'MYR': 'Malaysian Ringgit',
    'SGD': 'Singapore Dollar',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'JPY': 'Japanese Yen',
    'CNY': 'Chinese Yuan',
  };
}
