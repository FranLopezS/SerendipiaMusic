import 'package:flutter/material.dart';
import 'package:serendipiamusic/src/models/Album.dart';
import 'package:serendipiamusic/src/providers/search_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = "";
  SearchProvider searchProvider = SearchProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
      // Las acciones de nuestro AppBar.
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = ''; // Inicializar a vacío cuando se toca la 'X'.
          }
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del AppBar.
      //return Container();
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation
        ),
        onPressed: () {
          close(context, null);
        }
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {

      // Crea los resultados que se van a mostrar.
      if( query.isEmpty ) {
        return Container();
      }
      return _getResponseFutureBuilder();

    }
  
    @override
    Widget buildSuggestions(BuildContext context) {

      // Sugerencias que aparecen cuando la persona escribe.
      if( query.isEmpty ) {
        return Container();
      }
      return _getResponseFutureBuilder();

    }

    Widget _getResponseFutureBuilder() {
      return FutureBuilder(
        future: searchProvider.getSearchAlbums(query),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            final busqueda = snapshot.data; // Devuelve el SearchDeezer, que es la búsqueda.
            return _getList(busqueda); // Devuelve una lista con los resultados.
          } else {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
        }
      );
    }
    
    Widget _getList(dynamic search) {
      dynamic busqueda = search["data"];
      return ListView.builder(
        itemCount: busqueda.length, // Longitud de "Datum".
        itemBuilder: (context, i) {
          switch(busqueda[i]['type']) {
            /*case "track":
              return ListTile(
                title: Text(busqueda[i]['title']),
                subtitle: Text(busqueda[i]['artist']['name']+" · "+busqueda[i]['album']['title']),
                leading: Image.network(busqueda[i]['album']['cover_small']),
                onTap: () {

                },
              );
              break;*/
            case "album":
              try {
                return ListTile(
                  title: Text(busqueda[i]['title']),
                  subtitle: Text(busqueda[i]['artist']['name']),
                  leading: Image.network(busqueda[i]['cover_small']),
                  trailing: Icon(Icons.album),
                  onTap: () {
                    Album album = Album.fromJson(busqueda[i]);
                    Navigator.pushNamed(context, 'detalle_album', arguments: album);
                  },
                );
              } catch(Exception) {
                // Si un álbum da error por cualquier motivo, se salta.
                return Container();
              }
             
              break;
            /*case "artist":
              return ListTile(
                title: Text(busqueda[i]['name']),
                leading: Image.network(busqueda[i]['picture_small']),
                onTap: () {

                },
              );
              break;*/
            default:
              return Container();
              break;
          }
          
        }
      );
    }

    /*
    @override
    Widget buildSuggestions(BuildContext context) {
      // Sugerencias que aparecen cuando la persona escribe.

      // Se crea la lista sugerida.
      final listaSugerida = (query.isEmpty)
                              ? peliculasRecientes
                              : peliculas.where((peli) => peli.toLowerCase().startsWith(query.toLowerCase())
                              ).toList();

      return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: () {
              seleccion = listaSugerida[i];
              showResults(context);
            },
          );
        }
      );
    }
    
    */

}