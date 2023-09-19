import 'package:horarios/models/boleta.dart';
import 'package:horarios/models/itinerario.dart';
import 'package:mongo_dart/mongo_dart.dart';

var url = "mongodb+srv://admin:admin@cluster0.ckj07p1.mongodb.net/?retryWrites=true&w=majority";

class MongoDatabase {
  

  saveItinerario(Itinerario itinerario)async{
    var db = await Db.create(url);
    await db.open();
    var itColl = db.collection('itinerarios');
    var res = await itColl.insertOne(itinerario.toJson());

    
    
    return res.id.toString();
  }

  saveBoletas(String itinerario, List<Boleta> boletas)async{
    
    var db = await Db.create(url);
    await db.open();

    var boletasColl = db.collection('boletas');
    var boletasJson = boletas.map((e) => e.toJson()).toList();
    await boletasColl.insertMany(boletasJson);

  }

  getItinerarios()async{
    var db = await Db.create(url);
    List<Itinerario> itinerarios = [];

    await db.open();

    var coll = db.collection('itinerarios');

    var itinerariosJson = await  coll.find().toList();

    for(var itinerarioJson in itinerariosJson){
      itinerarios.add(Itinerario.fromJson(itinerarioJson));
    }

    return itinerarios;
  }

  getBoletasOfItinerarios(String id)async{
    var db =await  Db.create(url);
    List<Boleta> boletas = [];
    await db.open();
    var coll = db.collection('boletas');
    var boletasJson = await coll.find({"itinerario": id}).toList();

    for (var boletaJson in boletasJson){
      boletas.add(Boleta.fromJson(boletaJson));
    }

    return boletas;
  }

  deleteItinerario(){}
  
  
}