import 'dart:convert';

class DiscoPuntuado {
  String id;
  String id_artista;
  String puntuacion;
  String puesto_top;
  String comentario;

  DiscoPuntuado({
    this.id = "",
    this.id_artista = "",
    this.puntuacion = "",
    this.puesto_top = "",
    this.comentario = ""
  });

  List<DiscoPuntuado> muchosJson(dynamic json) {
    List<DiscoPuntuado> discos = [];
    dynamic rest = json['data'] as List;
    discos = rest.map<DiscoPuntuado>((json) => DiscoPuntuado.fromJson(json)).toList();
    return discos;
  }

  DiscoPuntuado welcomeFromJson(String str) => DiscoPuntuado.fromJson(json.decode(str));

  String welcomeToJson(DiscoPuntuado data) => json.encode(data.toJson());

  factory DiscoPuntuado.fromJson(Map<String, dynamic> json) => DiscoPuntuado(
    id          : json['id'].toString(),
    id_artista  : json['id_artista'].toString(),
    puntuacion  : json['puntuacion'].toString(),
    puesto_top  : json['puesto_top'].toString(),
    comentario  : json['comentario'].toString()
  );

  Map<String, dynamic> toJson() => {
    "id"          : id,
    "id_artista"  : id_artista,
    "puntuacion"  : puntuacion,
    "puesto_top"  : puesto_top,
    "comentario"  : comentario
  };

}