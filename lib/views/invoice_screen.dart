import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/file_downloader.dart';

class InvoiceScreen extends StatefulWidget {
  final String driverName;
  final String route;
  final String dateLabel;
  final String departureTime;
  final String arrivalTime;
  final String carModel;
  final int price;
  final String confirmationCode;

  const InvoiceScreen({
    super.key,
    required this.driverName,
    required this.route,
    required this.dateLabel,
    required this.departureTime,
    required this.arrivalTime,
    required this.carModel,
    required this.price,
    required this.confirmationCode,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  bool _isDownloading = false;

  Future<void> _downloadPdf() async {
    setState(() => _isDownloading = true);
    try {
      final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromInt(0xFF000066),
                              borderRadius: pw.BorderRadius.circular(6),
                            ),
                            child: pw.Text('T',
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Text('TransPorto',
                              style: pw.TextStyle(
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromInt(0xFF000066))),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text('TransPorto Togo SARL',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'Boulevard du 13 Janvier\nLomé, Togo\ncontact@transporto.tg',
                          style: const pw.TextStyle(
                              color: PdfColors.grey, fontSize: 12)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(16),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF1F5F9),
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Facture N°:  ${widget.confirmationCode}',
                            style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF000066))),
                        pw.SizedBox(height: 8),
                        pw.Text('Date:             ${widget.dateLabel}',
                            style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromInt(0xFF000066))),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 32),
              pw.Text('Facturé à:',
                  style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(0xFF000066))),
              pw.SizedBox(height: 4),
              pw.Container(
                width: 60,
                height: 2,
                color: PdfColor.fromInt(0xFF000066),
              ),
              pw.SizedBox(height: 12),
              pw.Text('Passager',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 32),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  children: [
                    pw.Container(
                      color: PdfColor.fromInt(0xFF0F172A),
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                              flex: 3,
                              child: pw.Text('DESCRIPTION',
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text('CONDUCTEUR\n/ VÉHICULE',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold))),
                          pw.Expanded(
                              flex: 2,
                              child: pw.Text('MONTANT\n(FCFA)',
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold))),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 24, horizontal: 12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Service de covoiturage interurbain',
                                    style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.normal)),
                                pw.SizedBox(height: 2),
                                pw.Text(widget.route,
                                    style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColor.fromInt(0xFF000066))),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                    'Départ: ${widget.departureTime}  |  Arrivée: ${widget.arrivalTime}',
                                    style: const pw.TextStyle(
                                        fontSize: 10, color: PdfColors.grey)),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(widget.driverName,
                                    style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 2),
                                pw.Text(widget.carModel,
                                    style: const pw.TextStyle(
                                        fontSize: 11, color: PdfColors.grey)),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text('${widget.price}',
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFF0F172A))),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      height: 60,
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          top: pw.BorderSide(color: PdfColors.grey300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 220,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Sous-total:',
                              style: const pw.TextStyle(color: PdfColors.grey)),
                          pw.Text('${widget.price} FCFA',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal)),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Taxes / Frais:',
                              style: const pw.TextStyle(color: PdfColors.grey)),
                          pw.Text('0 FCFA',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.normal)),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(0xFF000066),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('TOTAL:',
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('${widget.price} FCFA',
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Divider(),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Merci pour votre confiance ! - TransPorto',
                        style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.normal,
                            color: PdfColor.fromInt(0xFF334155))),
                    pw.SizedBox(height: 4),
                    pw.Text('Document généré automatiquement le ${widget.dateLabel}',
                        style: const pw.TextStyle(
                            fontSize: 11, color: PdfColors.grey)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName = 'facture_${widget.confirmationCode}.pdf';
    final path = await downloadFile(bytes, fileName);

    if (!mounted) return;
    setState(() => _isDownloading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Facture téléchargée: $path'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    if (!mounted) return;
    setState(() => _isDownloading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erreur: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000066)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Facture de voyage',
          style: TextStyle(
              color: Color(0xFF000066),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        actions: [
          _isDownloading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF000066)),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download, color: Color(0xFF000066)),
                  onPressed: _downloadPdf,
                  tooltip: 'Télécharger la facture',
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF000066),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.directions_car,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'TransPorto',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000066)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('TransPorto Togo SARL',
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text(
                        'Boulevard du 13 Janvier\nLomé, Togo\ncontact@transporto.tg',
                        style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'Facture N°:   ',
                              style: TextStyle(
                                  color: const Color(0xFF000066),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          TextSpan(
                              text: widget.confirmationCode,
                              style:
                                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ])),
                        const SizedBox(height: 8),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'Date:             ',
                              style: TextStyle(
                                  color: const Color(0xFF000066),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          TextSpan(
                              text: widget.dateLabel,
                              style:
                                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ])),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              const Text('Facturé à:',
                  style: TextStyle(
                      color: Color(0xFF000066),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 4),
              Container(width: 60, height: 2, color: const Color(0xFF000066)),
              const SizedBox(height: 12),
              const Text('Passager',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text('DESCRIPTION',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('CONDUCTEUR\n/ VÉHICULE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('MONTANT\n(FCFA)',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Service de covoiturage interurbain',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text(widget.route,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF000066))),
                                const SizedBox(height: 4),
                                Text(
                                    'Départ: ${widget.departureTime}  |  Arrivée: ${widget.arrivalTime}',
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(widget.driverName,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(widget.carModel,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('${widget.price}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Colors.grey.shade100)),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 220,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sous-total:',
                              style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text('${widget.price} FCFA',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Taxes / Frais:',
                              style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Text('0 FCFA',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000066),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            Text('${widget.price} FCFA',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Merci pour votre confiance ! - TransPorto',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF334155))),
                        const SizedBox(height: 4),
                        Text('Document généré automatiquement le ${widget.dateLabel}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 0,
                    child: Transform.rotate(
                      angle: -0.15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 14),
                                SizedBox(width: 4),
                                Text('PAYÉ',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        letterSpacing: 1)),
                              ],
                            ),
                            Text('VIA T-MONEY',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
