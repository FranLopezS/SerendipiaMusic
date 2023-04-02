import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SearchProvider {
  String _url      = 'api.deezer.com';
  String _language = 'es-ES';
  bool _cargando   = false;

  // Si no se pone el broadcast, solo una persona (widget) puede escuchar el Stream.
  // Este StreamController manejará una lista de películas.
  //final _popularesStreamController = StreamController<List<SearchDeezer>>.broadcast();

  // Se definen get y set para meter y coger info. del Stream.
  // Hay que pasar una lista de películas para que funcione.

  // Esta función agrega información al Stream.
  //Function(List<SearchDeezer>) get popularesSink => _popularesStreamController.sink.add;

  // Esta función coge información del Stream.
  //Stream<List<SearchDeezer>> get popularesStream => _popularesStreamController.stream;

  /*void disposeStreams() {
    _popularesStreamController?.close();
  }*/

  Future<dynamic> _procesarRespuesta(Uri url, int type) async {
    final resp = await http.get( url );
    dynamic decodedData = json.decode(resp.body);
    return decodedData;
  }

  Future<dynamic> getSearchTrackAPI(String dataSearch) async {
    final url = Uri.https(_url, '/album/$dataSearch/tracks', {
      'content-type' : 'application/json'
    });
    return await _procesarRespuesta(url, 1);
  }

  Future<dynamic> getSearchAlbums(String dataSearch) async {
    final url = Uri.https(_url, '/search/album', {
      'q' : dataSearch,
      'content-type' : 'application/json'
    });

    //print("URL: "+url.toString());
    return await _procesarRespuesta(url, 1);
  }

  Future<dynamic> getSearch(String dataSearch) async {
    final url = Uri.https(_url, '/search', {
      'q' : dataSearch,
      'content-type' : 'application/json'
    });

    print("URL: "+url.toString());
    //return await _procesarRespuesta(url);
    return null;
  }

  Future<dynamic> getAlbum(String idAlbum) async {
    final url = Uri.https(_url, '/album/$idAlbum', {
      'content-type' : 'application/json'
    });

    print("URL: "+url.toString());
    return await _procesarRespuesta(url, 1);
  }

  Future<dynamic> getAlbumsOfArtist(String idArtist) async {
    final url = Uri.https(_url, '/album/$idArtist/albums', {
      'content-type' : 'application/json'
    });

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    return decodedData;
  }

}