import 'dart:convert';

import 'package:serendipiamusic/src/models/Artist.dart';

class Album {
  String id;
  String title;
  String upc;
  String link;
  String share;
  String cover;
  String coverSmall;
  String coverMedium;
  String coverBig;
  String coverXl;
  String md5Image;
  String label;
  int nbTracks;
  String tracklist;
  bool explicitLyrics;
  Artist artist;

  Album({
    this.id = "",
    this.title = "",
    this.upc = "",
    this.link = "",
    this.share = "",
    this.cover = "",
    this.coverSmall = "",
    this.coverMedium = "",
    this.coverBig = "",
    this.coverXl = "",
    this.md5Image = "",
    this.label = "",
    this.nbTracks = 0,
    this.tracklist = "",
    this.explicitLyrics = false,
    this.artist = const Artist()
  });

  List<Album> muchosJson(dynamic json) {
    List<Album> albumes = [];
    dynamic rest = json['data'] as List;
    albumes = rest.map<Album>((json) => Album.fromJson(json)).toList();
    return albumes;
  }

  Album welcomeFromJson(String str) => Album.fromJson(json.decode(str));

  String welcomeToJson(Album data) => json.encode(data.toJson());

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    id          : json['id'].toString(),
    title       : json['title'].toString(),
    upc         : json['upc'].toString(),
    link        : json['link'].toString(),
    share       : json['share'].toString(),
    cover       : json['cover'].toString(),
    coverSmall  : json['cover_small'].toString(),
    coverMedium : json['cover_medium'].toString(),
    coverBig    : json['cover_big'].toString(),
    coverXl     : json['cover_xl'].toString(),
    md5Image    : json['md5_image'].toString(),
    label       : json['label'].toString(),
    // nbTracks    : json['nb_tracks'],
    tracklist             : json['tracklist'].toString(),
    // explicitLyrics        : json['explicit_lyrics'],
    artist                : Artist.fromJson(json['artist'])
  );

  Map<String, dynamic> toJson() => {
    "id"                      :id,
    "title"                   :title,
    "upc"                     :upc,
    "link"                    :link,
    "share"                   :share,
    "cover"                   :cover,
    "cover_small"             :coverSmall,
    "cover_medium"            :coverMedium,
    "cover_big"               :coverBig,
    "cover_xl"                :coverXl,
    "md5_image"               :md5Image,
    "label"                   :label,
    "nb_tracks"               :nbTracks,
    "tracklist"               :tracklist,
    "explicitLyrics"          :explicitLyrics,
    "artist"                  :artist
  };

}
