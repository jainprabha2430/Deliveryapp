import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'model/order_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';


class ChallanPrintScreen extends StatelessWidget {
  final OrderModel order;
  const ChallanPrintScreen({super.key, required this.order});

  static const String sellerAddress = 'NEAR SHIV MANDIR, GINNANI BASS,\nWARD NO-05, SARDARSHAHAR,\nChuru, Rajasthan, 331403';

  final List<Map<String, dynamic>> items = const [
    {'Sr': 1, 'Description': 'Product associated with Order', 'Qty': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Delivery Challan ",style: TextStyle(fontSize: 16),),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,

        actions: [
          TextButton.icon(
            icon: const Icon(Icons.print, color: Colors.blue),
            label: const Text(
              "Print",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _printPdf(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _topHeader(),
                const SizedBox(height: 12),
                _sellerBuyerSection(),
                const SizedBox(height: 12),
                _orderSummaryTable(),
                const SizedBox(height: 12),
                _itemsTable(),
                const SizedBox(height: 12),
                _signatureArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _printPdf(BuildContext context) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return _buildPdfContent(context);
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }
  pw.Widget _buildPdfContent(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _pdfTopHeader(),
        pw.SizedBox(height: 12),
        _pdfSellerBuyerSection(),
        pw.SizedBox(height: 12),
        _pdfOrderSummaryTable(),
        pw.SizedBox(height: 12),
        _pdfItemsTable(),
        pw.SizedBox(height: 12),
        _pdfSignatureArea(),
      ],
    );
  }

  // PDF में हेडर
  pw.Widget _pdfTopHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1)),
      child: pw.Column(
        children: [
          pw.Text(
            "DELIVERY CHALLAN",
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "Challan No: ${order.challanNo}",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // PDF में Seller/Buyer Section
  pw.Widget _pdfSellerBuyerSection() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "SELLER (SHIP FROM):",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        order.sellerName,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        sellerAddress,
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "GSTIN: ${order.sellerGSTIN}",
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 120,
                  height: 120,
                  child: pw.Container(
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 1),
                    ),
                    child: pw.Text("QR Code Space\n(Needs extra lib for PDF)"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // PDF में Order Summary Table
  pw.Widget _pdfOrderSummaryTable() {
    pw.Widget _pdfRow(String title, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "$title:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(child: pw.Text(value)),
          ],
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
      child: pw.Column(
        children: [
          _pdfRow("Order ID", order.orderId),
          _pdfRow("Order Date", order.orderDate),
          _pdfRow("Dispatch Date", order.expectedDispatchDate),
          _pdfRow("Buyer Name", order.customerName),
          _pdfRow("Buyer Contact", order.buyerContactNo),
        ],
      ),
    );
  }

  // PDF में Items Table
  pw.Widget _pdfItemsTable() {
    return pw.Table.fromTextArray(
        cellAlignment: pw.Alignment.centerLeft,
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.grey700),
        cellPadding: const pw.EdgeInsets.all(8),
        border: pw.TableBorder.all(color: PdfColors.black, width: 1),
        headers: <String>['Sr', 'Item Description', 'Qty'],
        data: <List<String>>[
          for (var item in items)
            ['${item['Sr']}', '${item['Description']}', '${item['Qty']}'],
        ],
        columnWidths: {
          0: const pw.FixedColumnWidth(40),
          1: const pw.FlexColumnWidth(3),
          2: const pw.FixedColumnWidth(50),
        },
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
        }
    );
  }

  // PDF में Signature Area
  pw.Widget _pdfSignatureArea() {
    pw.Widget _pdfSignatureLine(String title) {
      return pw.Row(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Divider(color: PdfColors.black, thickness: 1),
          ),
        ],
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "I/We hereby certify that goods are delivered in good condition.",
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12),
          ),
          pw.SizedBox(height: 40), // Increased height for signature space
          _pdfSignatureLine("Receiver’s Signature"),
          pw.SizedBox(height: 20),
          _pdfSignatureLine("Authorized Signatory"),
        ],
      ),
    );
  }

  // ************************************************
  // ********** ORIGINAL WIDGETS (unchanged) ********
  // ************************************************

  Widget _topHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
      child: Column(
        children: [
          const Text(
            "DELIVERY CHALLAN",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Challan No: ${order.challanNo}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _sellerBuyerSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SELLER (SHIP FROM):",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.sellerName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sellerAddress,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "GSTIN: ${order.sellerGSTIN}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black87, width: 1),
                  ),
                  child: QrImageView(
                    data: order.orderId,
                    size: 140,
                    version: QrVersions.auto,
                    errorStateBuilder: (cxt, err) {
                      return const Center(child: Text('QR Code Error'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _orderSummaryTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
      child: Column(
        children: [
          _row("Order ID", order.orderId),
          _row("Order Date", order.orderDate),
          _row("Dispatch Date", order.expectedDispatchDate),
          _row("Buyer Name", order.customerName),
          _row("Buyer Contact", order.buyerContactNo),
        ],
      ),
    );
  }
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  Widget _itemsTable() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
      child: Column(
        children: [
          _tableHeader(),
          const Divider(height: 1, thickness: 1),
          ...items.map(_tableRow),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade300,
      child: const Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              "Sr",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              "Item Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              "Qty",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text("${item['Sr']}")),
          Expanded(child: Text(item['Description'])),
          SizedBox(
            width: 50,
            child: Text(
              "${item['Qty']}",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  Widget _signatureArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "I/We hereby certify that goods are delivered in good condition.",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          ),
          const SizedBox(height: 20),
          _signatureLine("Receiver’s Signature"),
          const SizedBox(height: 20),
          _signatureLine("Authorized Signatory"),
        ],
      ),
    );
  }
  Widget _signatureLine(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(color: Colors.black, thickness: 1),
        ),
      ],
    );
  }
}