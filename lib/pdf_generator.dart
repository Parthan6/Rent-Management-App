import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'room_model.dart';

Future<void> generatePdf(Room room) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(
          children: [
            pw.Text('Rent Receipt', style: pw.TextStyle(fontSize: 40)),
            pw.SizedBox(height: 20),
            pw.Text('Payer: ${room.tenantName}'),
            pw.Text('Payee: Building Owner'),
            pw.Text('Amount Paid: ₹${room.rentAmount}'),
            pw.Text('Due: ₹${room.dueAmount}'),
            pw.Text('Date: ${DateTime.now()}'),
            pw.SizedBox(height: 50),
            pw.Text('Signature'),
            pw.SizedBox(height: 20),
            pw.Text('____________________'),
          ],
        ),
      ),
    ),
  );
  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}
