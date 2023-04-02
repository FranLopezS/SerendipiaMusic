import 'dart:convert';

class Artist {
  final String id;
  final String name;
  final String picture;
  final String pictureSmall;
  final String pictureMedium;
  final String pictureBig;
  final String pictureXl;
  final String tracklist;
  final String type;

  const Artist({
    this.id = "",
    this.name = "",
    this.picture = "",
    this.pictureSmall = "",
    this.pictureMedium = "",
    this.pictureBig = "",
    this.pictureXl = "",
    this.tracklist = "",
    this.type = ""
  });

  Artist welcomeFromJson(String str) => Artist.fromJson(json.decode(str));

  String welcomeToJson(Artist data) => json.encode(data.toJson());

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    id            : json['id'].toString(),
    name          : json['name'].toString(),
    picture       : json['picture'].toString(),
    pictureSmall  : json['picture_small'].toString(),
    pictureMedium : json['picture_medium'].toString(),
    pictureBig    : json['picture_big'].toString(),
    pictureXl     : json['picture_xl'].toString(),
    tracklist     : json['tracklist'].toString(),
    type          : json['type'].toString()
  );

  Map<String, dynamic> toJson() => {
    'id'            : id,
    'name'          : name,
    'picture'       : picture,
    'picture_small' : pictureSmall,
    'picture_medium': pictureMedium,
    'picture_big'   : pictureBig,
    'picture_xl'    : pictureXl,
    'tracklist'     : tracklist,
    'type'          : type
  };
  
}