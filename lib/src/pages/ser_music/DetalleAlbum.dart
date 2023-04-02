

import 'package:flutter/material.dart';
import 'package:serendipiamusic/src/models/Album.dart';
import 'package:serendipiamusic/src/models/CancionPuntuada.dart';
import 'package:serendipiamusic/src/models/DiscoPuntuado.dart';
import 'package:serendipiamusic/src/models/Track.dart';
import 'package:serendipiamusic/src/providers/db_provider.dart';
import 'package:serendipiamusic/src/providers/search_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//import 'package:numberpicker/numberpicker.dart';

class DetalleAlbum extends StatefulWidget {
  const DetalleAlbum({Key? key}) : super(key: key);

  @override
  _DetalleAlbumState createState() => _DetalleAlbumState();
}

class _DetalleAlbumState extends State<DetalleAlbum> {

  final SearchProvider _sProvider = SearchProvider();
  bool editando = false;
  bool _guardadoAnteriormente = false;
  List<double> notasTracks = [];
  List<String> idsTracks = [];
  Map<String, double> notasBBDD = Map<String, double>();
  bool _savingDisc = false;
  List<Track> tracklist = [];
  
  @override
  Widget build(BuildContext context) {
    final Album busqueda = ModalRoute.of(context)!.settings.arguments as Album; // Se recoge la info. del álbum.

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 250, 224),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          _crearAppbar(busqueda),
          _crearTitulos(busqueda),
          _crearBotonGuardar(busqueda)
          // _crearChart(busqueda)
        ],
      )
    );

  }

  Widget _crearChart(Album busqueda) {
    // while(notasBBDD.isEmpty) {
    //   Future.delayed(const Duration(
    //     seconds: 1
    //   ));
    // }

    if(notasBBDD.isNotEmpty) {
      return SliverToBoxAdapter(
        child: SfCartesianChart(
          // Initialize category axis
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Puntuaciones de ${busqueda.title}'),
          // legend: Legend(isVisible: true), //notasBBDD
          series: <LineSeries<Track, String>>[
            LineSeries<Track, String>(
              // Bind data source
              dataSource:  tracklist,
              xValueMapper: (Track t, _) => t.title,
              yValueMapper: (Track t, _) => notasBBDD[t.id]
            )
          ]
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: IconButton(
          onPressed: () {
            setState(() {
              
            });
          },
          icon: const Icon(Icons.update)
        ),
      );
    }
    
  }

  void _saveDisc(Album busqueda) {
    editando = false;
    double sumatorio = 0;
    for (var song in notasBBDD.entries) {
      sumatorio = (sumatorio + song.value);
      CancionPuntuada c = CancionPuntuada(
        id: song.key,
        id_disco: busqueda.id,
        puntuacion: song.value.toString(),
        comentario: ""
      );

      (_guardadoAnteriormente) ? DBProvider.db.updateCancion(c) : DBProvider.db.insertCancion(c);
    }

    double notaMedia = (sumatorio / notasBBDD.length);
    String notaMediaString = notaMedia.toStringAsFixed(2);

    DiscoPuntuado d = DiscoPuntuado(
      id: busqueda.id,
      id_artista: busqueda.artist.id,
      puntuacion: notaMediaString,
      puesto_top: "1",
      comentario: ""
    );

    (_guardadoAnteriormente) ? DBProvider.db.updateDisco(d) : DBProvider.db.insertDisco(d);

    setState(() {
      
    });
    
    _savingDisc = false;
  }

  Widget _crearBotonGuardar(Album busqueda) {
    if(editando) {
      return SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: const Text("btn2"),
              backgroundColor: const Color.fromARGB(255, 219, 85, 85),
              child: const Icon(Icons.delete),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: const Color.fromARGB(255, 31, 54, 61),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              '¿Realmente quieres borrar el álbum?',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            ElevatedButton(
                              child: const Text('Sí, borrar'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 255, 0, 0)
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                                DBProvider.db.deleteDisco(busqueda.id);
                                DBProvider.db.deleteCancionesByAlbum(busqueda.id);
                              }
                            ),
                            ElevatedButton(
                              child: const Text('Prefiero conservarlo'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(212, 163, 115, 1)
                              ),
                              onPressed: () => Navigator.pop(context)
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              heroTag: const Text("btn1"),
              backgroundColor: Color.fromARGB(255, 30, 187, 16),
              child: const Icon(Icons.save),
              onPressed: () {
                if(!_savingDisc) {
                  _savingDisc = true;
                  _saveDisc(busqueda);
                }
              }
            )
          ],
        ),
      );

    } else {
      return const SliverToBoxAdapter();

    }
    
  }

  Widget _crearTitulos(Album busqueda) {
    return SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            _crearInfoAlbum1(busqueda.artist.name, Icons.person, busqueda),
            const SizedBox(height: 5.0),
            _crearInfoAlbum2(busqueda.title, Icons.album),
            const SizedBox(height: 20.0),
            _crearNotaAlbum(busqueda, Icons.flash_on_rounded),
            const SizedBox(height: 20.0),
            _crearBotones(),
            _crearTracklist(busqueda)
          ],
        ),
    );
  }

  Widget _crearBotones() {
    if(!editando) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.toggle_off_sharp,
              size: 50.0
            ),
            onPressed: () {
              if(!_savingDisc) {
                editando = !editando;
                setState(() => {});
              }
            }
          ),
          const SizedBox(width: 20.0)
        ],
      );

    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(
              Icons.toggle_on_sharp,
              size: 50.0,
              color: Color.fromRGBO(212, 163, 115, 1)
            ),
            onPressed: () {
              editando = !editando;
              setState(() => {});
            }
          ),
          const SizedBox(width: 20.0)
        ],
      );

    }
    
  }

  Widget _crearTracklist(Album busqueda) {
    return FutureBuilder(
      future: _sProvider.getSearchTrackAPI(busqueda.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if(snap.hasData) {
          List<Track> tracks = [];
          List list = snap.data['data'];
          for(int i=0; i<list.length; i++) {
            tracks.add( Track.fromJson(list[i]) );
          }
          tracklist = tracks;

          if(!editando) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tracks.length,
              itemBuilder: (BuildContext context, int i) {
                // Consulta de cada canción.
                return FutureBuilder(
                  future: DBProvider.db.selectCancionPuntuadaID(tracks[i].id),
                  builder: (BuildContext context, AsyncSnapshot<List<CancionPuntuada>> listCancionPuntuada) {
                    if(listCancionPuntuada.hasData && listCancionPuntuada.data!.isNotEmpty) {
                      _guardadoAnteriormente = true;

                      CancionPuntuada cancion = listCancionPuntuada.data![0];
                      notasBBDD.addAll({cancion.id: double.parse(cancion.puntuacion)});

                      return ListTile(
                        tileColor: (i%2 == 0) ? const Color.fromRGBO(250, 237, 205, 1) : const Color.fromARGB(255, 254, 250, 224),
                        leading: const Icon(Icons.music_note),
                        title: Text(
                          tracks[i].title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic
                          )
                        ),
                        trailing: Text(
                          notasBBDD[tracks[i].id].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                          )
                        ),
                      );

                    } else {
                      if(!notasBBDD.containsKey(tracks[i].id)) notasBBDD.addAll({tracks[i].id: 0.00});

                      return ListTile(
                        tileColor: (i%2 == 0) ? const Color.fromRGBO(250, 237, 205, 1) : const Color.fromARGB(255, 254, 250, 224),
                        leading: const Icon(Icons.music_note),
                        title: Text(
                          tracks[i].title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic
                          )
                        ),
                        trailing: Text(
                          notasBBDD[tracks[i].id].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0
                          )
                        ),
                      );
                    }
                  },
                );
              },
            );

          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tracks.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  tileColor: (i%2 == 0) ? const Color.fromRGBO(250, 237, 205, 1) : const Color.fromARGB(255, 254, 250, 224),
                  leading: const Icon(Icons.music_note),
                  title: Text(
                    tracks[i].title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic
                    )
                  ),
                  trailing: Text(
                    notasBBDD[tracks[i].id].toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    )
                  ),
                  subtitle: Slider(
                    activeColor: const Color.fromRGBO(212, 163, 115, 1),
                    value: notasBBDD[tracks[i].id] ?? 0.0, // Si es null, será 0.
                    min: 0,
                    max: 10,
                    divisions: 40,
                    onChanged: (double value) {
                      setState(() {
                        notasBBDD[tracks[i].id] = value;
                      });
                    },
                  )
                );
              },
            );

          }

        } else { // No encuentra datos.
          return const CircularProgressIndicator();

        }
        
      },
    );
  }

  Widget _crearInfoAlbum1(String text, IconData icon, dynamic busqueda) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          Icon(icon),
          const SizedBox(width: 10.0),
          TextButton(
            onPressed: () {
              //Navigator.pushNamed(context, 'detalle_artista', arguments: busqueda);
            },
            child: Text(
              text, // TÍTULO DEL DISCO
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0
              )
            )
          )
          
        ],
      ),
    );
  }

  Widget _crearInfoAlbum2(String text, IconData icon) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          Icon(icon),
          const SizedBox(width: 25.0),
          Text(
            text, // TÍTULO DEL DISCO
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0
            )
          )
        ],
      ),
    );
  }

  Widget _crearNotaAlbum(Album busqueda, IconData icon) {
    return FutureBuilder(
      future: DBProvider.db.selectDiscosPuntuadosPorID(busqueda.id),
      builder: (BuildContext context, AsyncSnapshot<List<DiscoPuntuado>> albumesData) { // Solo devuelve 1 álbum, por lo que solo habrá un Album en la lista
        if(albumesData.hasData) { 
          if(albumesData.data!.isNotEmpty) { // Está puntuado.
            DiscoPuntuado album = albumesData.data![0];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10.0),
                  Icon(
                    icon,
                    color: const Color.fromARGB(255, 240, 209, 70),
                  ),
                  const SizedBox(width: 25.0),
                  Text(
                    album.puntuacion, // TÍTULO DEL DISCO
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    )
                  )
                ],
              ),
            );

          } else { // No está puntuado.
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10.0),
                  Icon(icon),
                  const SizedBox(width: 25.0),
                  const Text(
                    'Disco no puntuado', // TÍTULO DEL DISCO
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0
                    )
                  )
                ],
              ),
            );

          }
          
        } else { // No está puntuado.
          return const CircularProgressIndicator(); // No carga la bbdd.

        }

      },
    );
    
    /**/
  }

  Widget _crearAppbar(Album busqueda) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: const Color.fromRGBO(250, 237, 205, 1),
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      actions: const [],
      flexibleSpace: FlexibleSpaceBar( // Widget que se va a adaptar al appbar.
        centerTitle: true,
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(busqueda.coverXl),
          fit: BoxFit.cover,
        ),
      )
    );
  }

}

