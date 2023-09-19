class Itinerario {
  String id;
  final String ramal;

  Itinerario({required this.id, required this.ramal});

  factory Itinerario.fromJson(Map<String, dynamic> json) => Itinerario(
    id: json["_id"].toString(), 
    ramal: json["ramal"],
  );

  Map<String, dynamic> toJson() => {
      "ramal": ramal,
  };
}