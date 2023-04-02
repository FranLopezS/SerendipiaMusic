import 'dart:convert';

class CancionPuntuada {
  String id;
  String id_disco;
  String puntuacion;
  String comentario;

  CancionPuntuada({
    this.id = "",
    this.id_disco = "",
    this.puntuacion = "",
    this.comentario = ""
  });

  List<CancionPuntuada> muchosJson(dynamic json) {
    List<CancionPuntuada> canciones = [];
    dynamic rest = json['data'] as List;
    canciones = rest.map<CancionPuntuada>((json) => CancionPuntuada.fromJson(json)).toList();
    return canciones;
  }

  CancionPuntuada welcomeFromJson(String str) => CancionPuntuada.fromJson(json.decode(str));

  String welcomeToJson(CancionPuntuada data) => json.encode(data.toJson());

  factory CancionPuntuada.fromJson(Map<String, dynamic> json) => CancionPuntuada(
    id          : json['id'].toString(),
    id_disco    : json['id_disco'].toString(),
    puntuacion  : json['puntuacion'].toString(),
    comentario  : json['comentario'].toString()
  );

  Map<String, dynamic> toJson() => {
    "id"          : id,
    "id_disco"    : id_disco,
    "puntuacion"  : puntuacion,
    "comentario"  : comentario
  };

}