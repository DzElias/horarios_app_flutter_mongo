// To parse this JSON data, do
//
//     final boleta = boletaFromJson(jsonString);

import 'dart:convert';

Boleta boletaFromJson(String str) => Boleta.fromJson(json.decode(str));

String boletaToJson(Boleta data) => json.encode(data.toJson());

class Boleta {
    String nroOrden;
    String itinerario;
    List<Redondo> redondos;

    Boleta({
        required this.nroOrden,
        required this.itinerario,
        required this.redondos,
    });

    factory Boleta.fromJson(Map<String, dynamic> json) => Boleta(
        nroOrden: json["nroOrden"],
        itinerario: json["itinerario"],
        redondos: List<Redondo>.from(json["redondos"].map((x) => Redondo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nroOrden": nroOrden,
        "itinerario": itinerario,
        "redondos": List<dynamic>.from(redondos.map((x) => x.toJson())),
    };
}

class Redondo {
    String nroRedondo;
    List<HorarioPunto> horarioPuntos;

    Redondo({
        required this.nroRedondo,
        required this.horarioPuntos,
    });

    factory Redondo.fromJson(Map<String, dynamic> json) => Redondo(
        nroRedondo: json["nroRedondo"],
        horarioPuntos: List<HorarioPunto>.from(json["horarioPuntos"].map((x) => HorarioPunto.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "nroRedondo": nroRedondo,
        "horarioPuntos": List<dynamic>.from(horarioPuntos.map((x) => x.toJson())),
    };
}

class HorarioPunto {
    String punto;
    String horario;

    HorarioPunto({
        required this.punto,
        required this.horario,
    });

    factory HorarioPunto.fromJson(Map<String, dynamic> json) => HorarioPunto(
        punto: json["punto"],
        horario: json["horario"],
    );

    Map<String, dynamic> toJson() => {
        "punto": punto,
        "horario": horario,
    };
}
