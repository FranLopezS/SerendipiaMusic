import 'dart:convert';

import 'package:serendipiamusic/src/models/Album.dart';
import 'package:serendipiamusic/src/models/Artist.dart';

class Track {
  String id;
  bool readable;
  String title;
  String titleShort;
  String titleVersion;
  String isrc;
  String link;
  String share;
  String duration;
  int trackPosition;
  int diskNumber;
  String rank;
  String releaseDate;
  bool explicitLyrics;
  int explicitContentLyrics;
  int explicitContentCover;
  String preview;
  String md5Image;
  Artist artist;
  //Album album;
  String type;

  Track({
    this.id = "",
    this.readable = false,
    this.title = "",
    this.titleShort = "",
    this.titleVersion = "",
    this.isrc = "",
    this.link = "",
    this.share = "",
    this.duration = "",
    this.trackPosition = 0,
    this.diskNumber = 0,
    this.rank = "",
    this.releaseDate = "",
    this.explicitLyrics = false,
    this.explicitContentLyrics = 0,
    this.explicitContentCover = 0,
    this.preview = "",
    this.md5Image = "",
    this.artist = const Artist(),
    //this.album = const Album,
    this.type = ""
  });

  Track welcomeFromJson(String str) => Track.fromJson(json.decode(str));

  String welcomeToJson(Track data) => json.encode(data.toJson());

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id                    : json['id'].toString(),
    readable              : json['readable'],
    title                 : json['title'].toString(),
    titleShort            : json['title_short'].toString(),
    titleVersion          : json['title_version'].toString(),
    isrc                  : json['isrc'].toString(),
    link                  : json['link'].toString(),
    share                 : json['share'].toString(),
    duration              : json['duration'].toString(),
    trackPosition         : json['track_position'],
    diskNumber            : json['disk_number'],
    rank                  : json['rank'].toString(),
    releaseDate           : json['release_date'].toString(),
    explicitLyrics        : json['explicit_lyrics'],
    explicitContentLyrics : json['explicit_content_lyrics'],
    explicitContentCover  : json['explicit_content_cover'],
    preview               : json['preview'].toString(),
    md5Image              : json['md5_image'],
    artist                : Artist.fromJson(json['artist']),
    //album                 : Album.fromJson(json['album']),
    type                  : json['type']
  );

  Map<String, dynamic> toJson() => {
    'id' : id,
    'readable' : readable,
    'title' : title,
    'title_short' : titleShort,
    'title_version' : titleVersion,
    'isrc' : isrc,
    'link' : link,
    'share' : share,
    'duration' : duration,
    'track_position' : trackPosition,
    'disk_number' : diskNumber,
    'rank' : rank,
    'release_date' : releaseDate,
    'explicit_lyrics' : explicitLyrics,
    'explicit_content_lyrics' : explicitContentLyrics,
    'explicit_content_cover' : explicitContentCover,
    'preview' : preview,
    'md5_image' : md5Image,
    'artist' : artist,
    //'album' : album,
    'type' : type,
  };

}