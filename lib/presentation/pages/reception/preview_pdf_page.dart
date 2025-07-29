import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/keen_icon_constants.dart';
import '../../../dependency_injection.dart';
import '../../../domain/repositories/file_repository.dart';
import '../../widgets/shared/app_bar/basic_app_bar.dart';
import '../../widgets/shared/button/basic_button.dart';
import '../../widgets/shared/view/error_retry_view.dart';

@RoutePage()
class PreviewPdfPage extends StatefulWidget {
  const PreviewPdfPage({super.key, required this.path, this.title});
  final String? title;
  final String path;

  @override
  State<PreviewPdfPage> createState() => _PreviewPdfPageState();
}

class _PreviewPdfPageState extends State<PreviewPdfPage> {
  final FileRepository fileRepository = serviceLocator.get();
  late Future<Uint8List> _pdfBytesFuture;

  @override
  void initState() {
    super.initState();
    _loadPdfDocument();
  }

  void _loadPdfDocument() {
    setState(() {
      _pdfBytesFuture = fileRepository.getFile(widget.path);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const BasicAppBar(
          title: 'Preview PDF',
          showBackButton: true,
          icon: KeenIconConstants.officeBagOutline,
        ),
        const Divider(thickness: 1, color: Colors.grey),
        Expanded(
          child: FutureBuilder<Uint8List>(
            future: _pdfBytesFuture,
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return ErrorRetryView(
                  errorMessage: 'Gagal memuat PDF: ${snapshot.error.toString()}',
                  onRetry: _loadPdfDocument,
                );
              } else if (snapshot.hasData) {

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Preview File PO'),
                          BasicButton(
                            icon: KeenIconConstants.folderDownOutline,
                              text: 'Download File',
                              onClick: () => savePdfInternally(snapshot.data!, context)
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SfPdfViewerTheme(
                        data: const SfPdfViewerThemeData(
                          backgroundColor: Color(0xFFE0E0E0),
                        ),
                        child: SfPdfViewer.memory(
                          snapshot.data!,
                          canShowSignaturePadDialog: false,
                          canShowScrollHead: false,
                          pageSpacing: 8,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada data PDF tersedia.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    ),
  );


  Future<void> savePdfInternally(Uint8List data, BuildContext context) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File file = File('${appDir.path}/${const Uuid().v1()}');
      await file.writeAsBytes(data);

      debugPrint(file.path);

      OpenFilex.open(file.path, type: 'application/pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File disimpan di direktori internal:\n${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan file: $e')),
      );
    }
  }
}