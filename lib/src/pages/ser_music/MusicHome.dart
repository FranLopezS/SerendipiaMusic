import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:serendipiamusic/src/models/Album.dart';
import 'package:serendipiamusic/src/models/DiscoPuntuado.dart';
import 'package:serendipiamusic/src/providers/db_provider.dart';
import 'package:serendipiamusic/src/providers/search_provider.dart';
import 'package:serendipiamusic/src/search/SearchDelegate.dart';

class MusicHome extends StatefulWidget {
  const MusicHome({Key? key}) : super(key: key);

  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {

  final SearchProvider _sProvider = new SearchProvider();
  late ScrollController _scrollController;
  int _maxItems = 10;
  List<Album> cacheAlbumes = [];
  List<String> cacheAlbumesIds = [];

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if(_scrollController.hasClients) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 237, 205, 1),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Color.fromRGBO(212, 163, 115, 1) ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(), query: '');
              },
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 254, 250, 224),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              
            });
          },
          child: SafeArea(
            child: _getColumn(),
          ),
        )
      );

    // } else {
    //   return const CircularProgressIndicator();
    // }
    
  }

  Widget _getColumn() {
    return Column(
      children: [
        _getRowDiscos(1),
        // Text('Guardados'),
        // _getRowDiscos(2),
        // Text('Recomendaciones'),
        // _getRowDiscos(3)
      ],
    );
  }

  Widget _cargarDiscosPuntuados() {
    return FutureBuilder(
      future: DBProvider.db.selectDiscosPuntuados(_maxItems),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData) {
          List<DiscoPuntuado> albumesPuntuados = snapshot.data;

          int acumulaciones = 0;
          //bool notaIgual = false;
          double notaAnterior = 11;
          return Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: albumesPuntuados.length,
              itemBuilder: (BuildContext context, int index) {

                if(double.parse(albumesPuntuados[index].puntuacion) == notaAnterior) {
                  acumulaciones++;
                } else {
                  acumulaciones = 0;
                }

                notaAnterior = double.parse(albumesPuntuados[index].puntuacion);

                int puesto = (index + 1) - acumulaciones;

                if(cacheAlbumesIds.contains(albumesPuntuados[index].id)) {
                  int indexOf = cacheAlbumesIds.indexOf(albumesPuntuados[index].id);
                  Album album = cacheAlbumes[indexOf];

                  return detalleLinea(albumesPuntuados, index, album, puesto);

                } else {
                  return FutureBuilder(
                    future: _sProvider.getAlbum(albumesPuntuados[index].id),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.hasData) {
                        if(snapshot.data != null) {
                          Album album = Album.fromJson(snapshot.data);
                          return detalleLinea(albumesPuntuados, index, album, puesto);
                          
                        } else {
                          return Container();
                        }

                      } else {
                        return const SizedBox(
                          width: 10.0,
                          //child: CircularProgressIndicator()
                        );

                      }

                    },
                  );
                  
                }
              },
            ),
          );

        } else {
          return const SizedBox(
            width: 50.0,
            //child: CircularProgressIndicator()
          );
        }
      },
    );
  }

  Widget detalleLinea(List<DiscoPuntuado> albumesPuntuados, int index, album, int puesto) {
    double puntos = double.parse(albumesPuntuados[index].puntuacion);
    Color? color;
    Color? colorBg;
    if(puntos == 10) {
      color = const Color.fromARGB(255, 247, 235, 131);
      colorBg = const Color.fromARGB(100, 247, 235, 131);
    } else if(puntos < 10 && puntos >= 9.50) {
      color = const Color.fromARGB(255, 160, 173, 162);
      colorBg = const Color.fromARGB(100, 160, 173, 162);
    } else if(puntos < 9.50 && puntos >= 9) {
      color = const Color.fromARGB(255, 185, 180, 130);
      colorBg = const Color.fromARGB(100, 185, 180, 130);
    } else {
      color = const Color.fromARGB(0, 255, 255, 255);
      colorBg = const Color.fromARGB(0, 255, 255, 255);
    }
    
    cacheAlbumes.add(album); cacheAlbumesIds.add(albumesPuntuados[index].id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'detalle_album', arguments: album);
      },
      child: Container(
        decoration: BoxDecoration(
          /*image: DecorationImage(
            image: NetworkImage(album.coverXl),
            fit: BoxFit.cover
          )*/
          color: colorBg
        ),
        child: ListTile(
          title: Text(
            album.title,
            style: const TextStyle(
              fontSize: 17.0,
              color: Color.fromARGB(255, 97, 74, 52),
              // backgroundColor: Colors.white
            ),
          ),
          subtitle: Text(
            album.artist.name,
            style: const TextStyle(
              fontSize: 10.0,
              color: Color.fromARGB(255, 97, 74, 52),
              fontStyle: FontStyle.italic,
              // backgroundColor: Colors.black
            ),
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30.0,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle
                ),
                child: Text(
                  puesto.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              FadeInImage(
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(album.cover),
                fit: BoxFit.cover
              )
            ],
          ),
          trailing: Text(
            albumesPuntuados[index].puntuacion,
            style: const TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 97, 74, 52),
              // backgroundColor: Color.fromARGB(255, 31, 54, 61)
            ),
          ),
        ),
      ),
    );
  }

  Widget _cargarOtros() {
    return FutureBuilder(
      future: _sProvider.getSearchAlbums('Amaia Montero'),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData) {

          List<Album> albumes = [];
          List list = snapshot.data['data'] as List;
          for(int i=0; i<list.length; i++) {
            albumes.add( Album.fromJson(list[i]) );
          }

          return Expanded(
            child: SizedBox(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albumes.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'detalle_album', arguments: albumes[i]);
                    },
                    child: SizedBox(
                      width: 100,
                      child: Image(
                        image: NetworkImage(albumes[i].coverXl),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(); // Sin datos.
        }
      },
    );
  }

  Widget _getRowDiscos(int buscar) {
    switch (buscar) {
      case 1:
        return _cargarDiscosPuntuados();
      default:
        return _cargarOtros();
    }
  }
  
  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _maxItems += 10;
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        
      });
    }
  }
}