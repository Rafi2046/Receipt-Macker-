import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'file_save_service.dart';
import 'image_picker_service.dart';
import 'image_storage_service.dart';
import 'pdf/html_pdf_converter.dart';
import 'pdf/pdf_fonts.dart';
import 'pdf/pdf_print_service.dart';
import 'pdf/pdf_raster_service.dart';
import 'preferences/app_preferences.dart';
import 'share_service.dart';

part 'service_providers.g.dart';

/// Overridden in bootstrap with the loaded preferences (and with a fake in tests).
@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) =>
    throw UnimplementedError('appPreferencesProvider must be overridden');

@Riverpod(keepAlive: true)
ImageStorageService imageStorageService(Ref ref) =>
    ImageStorageService(getApplicationDocumentsDirectory);

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(Ref ref) => ImagePickerService();

@Riverpod(keepAlive: true)
HtmlPdfConverter htmlPdfConverter(Ref ref) => HtmlPdfConverter();

@Riverpod(keepAlive: true)
PdfFonts pdfFonts(Ref ref) => PdfFonts();

@Riverpod(keepAlive: true)
PdfRasterService pdfRasterService(Ref ref) => PdfRasterService();

@Riverpod(keepAlive: true)
PdfPrintService pdfPrintService(Ref ref) => PdfPrintService();

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) => ShareService();

@Riverpod(keepAlive: true)
FileSaveService fileSaveService(Ref ref) => FileSaveService();

/// Where generated files (PDFs to share) are written. Cleared by Android
/// when space runs low.
@Riverpod(keepAlive: true)
Future<Directory> Function() cacheDirectory(Ref ref) => getTemporaryDirectory;
