/// A sample client and what they still owe.
class StudioClient {
  const StudioClient({
    required this.name,
    required this.phone,
    required this.outstandingMinor,
  });

  final String name;
  final String phone;
  final int outstandingMinor;
}
