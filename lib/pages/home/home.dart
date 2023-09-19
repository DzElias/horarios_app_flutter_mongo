import 'package:flutter/material.dart';
import 'package:horarios/pages/itinerarios/itinerarios.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              title: 'Itinerarios',
              ftn: redirItinerarios,
            ),

            const SizedBox(
              height: 20,
            ),

            CustomButton(
              title: 'Choferes',
              ftn: redirChoferes,
            ),

            const SizedBox(
              height: 20,
            ),


            
            
          ],
        ),
      ),
    );
  }


  void registrarBoleta() {
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrarBoletaPage()));
  }

  void redirImprimirBoleta() {

  }

  void redirItinerarios(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ItinerariosPage()));
  }

  void redirChoferes(){

  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key, required this.title, required this.ftn,
  }) : super(key: key);

  final String title;
  final void Function() ftn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ftn(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 200,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Center(
            child: Text(title, style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),),
          ),
        ),
      ),
    );
  }
}
