import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horarios/models/boleta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPdfPage extends StatefulWidget {
  const PrintPdfPage({Key? key, required this.boleta}) : super(key: key);
  final Boleta boleta;

  @override
  State<PrintPdfPage> createState() => _PrintPdfPageState();
}

class _PrintPdfPageState extends State<PrintPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Imprimir',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PdfPreview(
        build: (context) => makePdf(widget.boleta),
      ),
    );
  }

  Future<Uint8List> makePdf(Boleta boleta) async {
    final pdf = pw.Document();

    // boleta.redondos.map((e) {
    //   pdf.addPage(
    //     pw.Page(
    //       build: (context){
    //         return pw.Table(
    //           border: pw.TableBorder.all(color: PdfColors.black),
    //           children: [
    //             pw.TableRow(
    //               children: [
    //                 pw.Text('Nro Orden', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    //                 pw.Text(boleta.nroOrden)
    //               ]
    //             )
    //           ]
    //         );
    //       }
    //     )
    //   );
    // });
    int i = 0;
    for (i; i < boleta.redondos.length; i++) {
      var redondo = boleta.redondos[i];
      pdf.addPage(pw.Page(build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))
              ]
            ),
            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Nro Orden: ${boleta.nroOrden}', style: pw.TextStyle(fontSize: 18)),
            
            pw.Text('Redondo: ${redondo.nroRedondo}', style: pw.TextStyle(fontSize: 18)),
              ]
            ),
            pw.SizedBox(height: 20),
            pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    child: pw.Text(
                      'Punto',
                      style: pw.Theme.of(context).header4,
                      textAlign: pw.TextAlign.left,
                    ),
                    padding: const pw.EdgeInsets.all(10),
                  ),

                  pw.Padding(
                    child: pw.Text(
                      'Horario',
                      style: pw.Theme.of(context).header4,
                      textAlign: pw.TextAlign.left,
                    ),
                    padding: const pw.EdgeInsets.all(10),
                  ),
                ]
              ),

              ...redondo.horarioPuntos.map((e) => pw.TableRow(children: [
                pw.Padding(
                    child: pw.Text(
                      e.punto,
                      style: pw.Theme.of(context).header4,
                      textAlign: pw.TextAlign.left,
                    ),
                    padding: const pw.EdgeInsets.all(10),
                  ),

                  pw.Padding(
                    child: pw.Text(
                      e.horario.substring(0,5),
                      style: pw.Theme.of(context).header4,
                      textAlign: pw.TextAlign.left,
                    ),
                    padding: const pw.EdgeInsets.all(10),
                  ),
              ])).toList()




            ])
          ]
        );
      }));
    }

    return pdf.save();
  }
}
