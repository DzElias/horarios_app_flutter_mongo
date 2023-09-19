import 'package:flutter/material.dart';
import 'package:horarios/data/mongo_database.dart';
import 'package:horarios/models/boleta.dart';
import 'package:horarios/models/itinerario.dart';
import 'package:horarios/pages/printPdfPage/print_pdf_page.dart';

class ItinerarioPage extends StatefulWidget {
  const ItinerarioPage({Key? key, required this.itinerario}) : super(key: key);
  final Itinerario itinerario;

  @override
  State<ItinerarioPage> createState() => _ItinerarioPageState();
}

class _ItinerarioPageState extends State<ItinerarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,      
        title: const Text('Seleccionar boleta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),

        centerTitle: true,
      ),

      body: Container(
        child: FutureBuilder(
          future: getBoletas(), 
          builder: (_, snapshot){

            if(snapshot.hasData){
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
              
                    const SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Nro Orden', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                        itemCount: (snapshot.data as List<Boleta>).length,
                        itemBuilder: (ctx,i) => Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox( child: Text((snapshot.data as List<Boleta>)[i].nroOrden, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18))),
                        
                              SizedBox( child: MouseRegion(cursor: SystemMouseCursors.click, child:GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => PrintPdfPage(boleta: (snapshot.data as List<Boleta>)[i])));
                                        },
                                        child: const Row(
                                children: [
                                  Text('Imprimir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                  SizedBox(width: 10,),
                                  
                                        
                                            
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                    
                                ],
                              ),)
                                    
                              
                          ))],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator(color: Colors.white,));
          }
        ),
      ),
    );

  }
    getBoletas()async{
      List<Boleta> boletas = await MongoDatabase().getBoletasOfItinerarios(widget.itinerario.id);
      return boletas;

    }
}