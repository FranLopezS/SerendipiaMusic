
import 'package:flutter/material.dart';
import 'package:serendipiamusic/src/pages/SplashScreen.dart';
import 'package:serendipiamusic/src/pages/ser_music/DetalleAlbum.dart';
import 'package:serendipiamusic/src/pages/ser_music/MusicHome.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    '/'                : (BuildContext context) => SplashScreen(),
    'music_home'       : (BuildContext context) => MusicHome(),
    'detalle_album'    : (BuildContext context) => DetalleAlbum()
  };
}
