import 'studio_client.dart';
import 'studio_invoice.dart';
import 'studio_snapshot.dart';
import 'studio_status.dart';

/// Realistic sample numbers for the mock. Not stored and not the user's data.
abstract final class StudioDemo {
  static const String owner = 'Rahman';
  static const String business = 'Rahman Traders';
  static const String editorClient = 'Karim Store';
  static const String editorPhone = '01811223344';

  static final List<StudioSnapshot> months = [
    StudioSnapshot(
      month: DateTime(2026, 5),
      invoicedMinor: 3200000,
      receivedMinor: 2800000,
      outstandingMinor: 400000,
      changePercent: 4,
    ),
    StudioSnapshot(
      month: DateTime(2026, 6),
      invoicedMinor: 4100000,
      receivedMinor: 3600000,
      outstandingMinor: 900000,
      changePercent: 8,
    ),
    StudioSnapshot(
      month: DateTime(2026, 7),
      invoicedMinor: 2800000,
      receivedMinor: 2500000,
      outstandingMinor: 1200000,
      changePercent: -6,
    ),
    StudioSnapshot(
      month: DateTime(2026, 8),
      invoicedMinor: 5200000,
      receivedMinor: 4000000,
      outstandingMinor: 2400000,
      changePercent: 18,
    ),
    StudioSnapshot(
      month: DateTime(2026, 9),
      invoicedMinor: 3800000,
      receivedMinor: 3100000,
      outstandingMinor: 1900000,
      changePercent: -4,
    ),
    StudioSnapshot(
      month: DateTime(2026, 10),
      invoicedMinor: 4800000,
      receivedMinor: 2150000,
      outstandingMinor: 2650000,
      changePercent: 12,
    ),
  ];

  static const List<StudioInvoice> invoices = [
    StudioInvoice(
      client: 'Bangladesh Garments',
      number: 'INV-0005',
      phone: '01711223344',
      totalMinor: 4500000,
      paidMinor: 0,
      dueInDays: 3,
      status: StudioStatus.sent,
      inOctober: true,
    ),
    StudioInvoice(
      client: 'Nusrat Ahmed',
      number: 'INV-0008',
      phone: '01612345678',
      totalMinor: 2400000,
      paidMinor: 960000,
      dueInDays: 3,
      status: StudioStatus.partial,
      inOctober: true,
    ),
    StudioInvoice(
      client: 'মেসার্স রহমান অ্যান্ড সন্স',
      number: 'INV-0004',
      phone: '01911223344',
      totalMinor: 1820000,
      paidMinor: 0,
      dueInDays: -5,
      status: StudioStatus.overdue,
      inOctober: true,
    ),
    StudioInvoice(
      client: 'Karim Store',
      number: 'INV-0001',
      phone: '01811223344',
      totalMinor: 863700,
      paidMinor: 863700,
      dueInDays: 12,
      status: StudioStatus.paid,
      inOctober: true,
    ),
    StudioInvoice(
      client: 'Liza Boutique',
      number: 'INV-0006',
      phone: '01511223344',
      totalMinor: 1560000,
      paidMinor: 1560000,
      dueInDays: -2,
      status: StudioStatus.paid,
      inOctober: false,
    ),
    StudioInvoice(
      client: 'Farhan Traders',
      number: 'INV-0002',
      phone: '01311223344',
      totalMinor: 320000,
      paidMinor: 0,
      dueInDays: 20,
      status: StudioStatus.draft,
      inOctober: false,
    ),
  ];

  static const List<StudioClient> clients = [
    StudioClient(
      name: 'Bangladesh Garments',
      phone: '01711223344',
      outstandingMinor: 4500000,
    ),
    StudioClient(
      name: 'Farhan Traders',
      phone: '01311223344',
      outstandingMinor: 320000,
    ),
    StudioClient(
      name: 'Karim Store',
      phone: '01811223344',
      outstandingMinor: 0,
    ),
    StudioClient(
      name: 'Liza Boutique',
      phone: '01511223344',
      outstandingMinor: 0,
    ),
    StudioClient(
      name: 'Nusrat Ahmed',
      phone: '01612345678',
      outstandingMinor: 1440000,
    ),
    StudioClient(
      name: 'মেসার্স রহমান অ্যান্ড সন্স',
      phone: '01911223344',
      outstandingMinor: 1820000,
    ),
  ];

  static const filterCounts = [24, 8, 3, 12, 1];
}
