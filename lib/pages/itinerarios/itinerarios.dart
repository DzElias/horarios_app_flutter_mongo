import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:horarios/data/mongo_database.dart';
import 'package:horarios/models/boleta.dart';
import 'package:horarios/models/itinerario.dart';
import 'package:horarios/pages/itinerario/itinerario.dart';
import 'package:permission_handler/permission_handler.dart';

class ItinerariosPage extends StatefulWidget {
  const ItinerariosPage({Key? key}) : super(key: key);

  @override
  State<ItinerariosPage> createState() => _ItinerariosPageState();
}

class _ItinerariosPageState extends State<ItinerariosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Itinerarios',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.green,
      body: FutureBuilder(
          future: MongoDatabase().getItinerarios(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              List<Itinerario> itinerarios = snapshot.data as List<Itinerario>;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: GestureDetector(
                        onTap: () async {
                          await cargarItinerario();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.file_open,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('CARGAR ITINERARIO',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 150,
                            child: Text(
                              'Ramal',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox()
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: itinerarios
                          .map((e) => Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        child: Text(
                                          e.ramal,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ItinerarioPage(
                                                    itinerario: e)));
                                      },
                                      child: const MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 30,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }),
    );
  }

  Future<void> cargarItinerario() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    var statusAf = await Permission.manageExternalStorage.status;

    if (statusAf.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        var buses = [];
        List<Boleta> boletas = [];

        int i = 0;
        int j = 0;

        int jBus = -1;

        int jMinutos = -1;

        int iPrimeraFila = -1;

        String name = '';
        bool swName = false;

        String id = "";

        bool swPrimeraFila = false;

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            for (var data in row) {
              if (data != null) {
                if (data.value.toString().trim() == 'BUS') {
                  jBus = j;
                }

                if (!swName) {
                  name = data.value.toString().trim();
                  var _id = await MongoDatabase()
                      .saveItinerario(Itinerario(ramal: name, id: ''));
                  id = _id;
                  swName = true;
                }

                if (data.value.toString().trim() == 'MINUTOS') {
                  jMinutos = j;
                }

                if (swPrimeraFila) {
                  if (buses.indexWhere((element) =>
                          element ==
                          excel.tables[table]!.rows[i][jBus]!.value) ==
                      -1) {
                    var bus = excel.tables[table]!.rows[i][jBus]!.value;
                    var x = 0;
                    var k = 0;
                    var contador = 0;
                    List<HorarioPunto> horarioPuntos = [];
                    List<Redondo> redondos = [];

                    for (var table in excel.tables.keys) {
                      for (var row in excel.tables[table]!.rows) {
                        if (excel.tables[table]!.rows[x][jBus] != null) {
                          if (excel.tables[table]!.rows[x][jBus]!.value ==
                              bus) {
                            contador++;
                            Redondo redondo = Redondo(
                                nroRedondo: contador.toString(),
                                horarioPuntos: []);

                            for (var data in row) {
                              if (data != null) {
                                if (k > jBus && k < jMinutos) {
                                  HorarioPunto horarioPunto = HorarioPunto(
                                      horario: excel
                                          .tables[table]!.rows[x][k]!.value
                                          .toString()
                                          .trim(),
                                      punto: excel.tables[table]!
                                          .rows[iPrimeraFila][k]!.value
                                          .toString()
                                          .trim());
                                  horarioPuntos.add(horarioPunto);
                                }
                              }

                              k++;
                            }
                            k = 0;
                            redondo.horarioPuntos = horarioPuntos;
                            redondos.add(redondo);
                            horarioPuntos = [];
                          }
                        }
                        x++;
                      }
                    }

                    Boleta boleta = Boleta(
                        itinerario: id.toString(),
                        redondos: redondos,
                        nroOrden: bus.toString());
                    boletas.add(boleta);

                    buses.add(excel.tables[table]!.rows[i][jBus]!.value);
                  }
                }

                if (data.value.toString().trim() == 'DISPONIBIL') {
                  swPrimeraFila = true;
                  iPrimeraFila = i;
                }
              }

              j++;
            }
            j = 0;
            i++;
          }
        }

        await MongoDatabase().saveBoletas(id.toString(), boletas);
      } else {
        // User canceled the picker
      }
    }
  }
}
