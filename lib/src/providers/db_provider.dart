import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serendipiamusic/src/models/Album.dart';
import 'package:serendipiamusic/src/models/CancionPuntuada.dart';
import 'package:serendipiamusic/src/models/DiscoPuntuado.dart';
import 'package:serendipiamusic/src/models/Track.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {

  // Sólo podrá haber 1 instancia a la vez de esta clase.
  static late Database _database;
  static final DBProvider db = DBProvider._(); // Inicializar con constructor privado.

  DBProvider._();

  Future<Database> get database async {
    //if(_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 3,
      onOpen: (Database db) async {
        // await db.execute('delete from canciones_puntuadas');
        // await db.execute('delete from discos_puntuados');
        // await db.execute('delete from discos_guardados');
      },
      onUpgrade: (db, oldVer, newVer) {

      },
      onCreate: (Database db, int version) async {

        // Lo que se crea cuando se crea la bbdd.

        // Se guarda el track, el disco, la nota y el comentario.
        await db.execute(
          'CREATE TABLE canciones_puntuadas ('
          ' id TEXT PRIMARY KEY, '
          ' id_disco TEXT, '
          ' puntuacion TEXT, '
          ' comentario TEXT '
          ')'
        );

        // Discos puntuados. Se guarda id de disco, id de artista, la puntuación que le asignas, el puesto en el top y el comentario.
        await db.execute(
          'CREATE TABLE discos_puntuados ('
          ' id TEXT PRIMARY KEY, '
          ' id_artista TEXT, '
          ' puntuacion TEXT, '
          ' puesto_top TEXT, '
          ' comentario TEXT '
          ')'
        );

        await db.execute(
          'CREATE TABLE discos_guardados ('
          ' id TEXT PRIMARY KEY, '
          ' id_artista TEXT '
          ')'
        );

      }
    );
  }

  // === Canciones puntuadas ===
  Future<List<CancionPuntuada>> selectCancionPuntuadaIDAlbum(String idAlbum) async {
    final db = await database;
    final res = await db.query('canciones_puntuadas',
      where: 'id_disco = ?',
      whereArgs: [idAlbum]
    );
    List<CancionPuntuada> list = res.isNotEmpty // Si la consulta no está vacía...
                                      ? res.map((e) => CancionPuntuada.fromJson(e)).toList() // Devuelve la lista de respuestas.
                                      : []; // Devuelve una lista vacía.
    return list;
  }

  Future<List<CancionPuntuada>> selectCancionPuntuadaID(String idTrack) async {
    final db = await database;
    final res = await db.query('canciones_puntuadas',
      where: 'id = ?',
      whereArgs: [idTrack]
    );
    List<CancionPuntuada> list = res.isNotEmpty // Si la consulta no está vacía...
                                      ? res.map((e) => CancionPuntuada.fromJson(e)).toList() // Devuelve la lista de respuestas.
                                      : []; // Devuelve una lista vacía.
    return list;
  }

  insertCancion(CancionPuntuada newTrack) async {
    final db = await database;
    final res = await db.insert('canciones_puntuadas', <String, dynamic> {
      "id"    : newTrack.id,
      "id_disco"  : newTrack.id_disco,
      "puntuacion"  : newTrack.puntuacion,
      "comentario"  : newTrack.comentario
    });
    return res;
  }

  deleteCancionesByAlbum(String idAlbum) async {
    final db = await database;
    final res = await db.delete('canciones_puntuadas',
      where: 'id_disco = ?',
      whereArgs: [idAlbum]
    );
    return res;
  }

  updateCancion(CancionPuntuada newTrack) async {
    final db = await database;
    final res = await db.update('canciones_puntuadas', <String, dynamic> {
        "id"          : newTrack.id,
        "id_disco"    : newTrack.id_disco,
        "puntuacion"  : newTrack.puntuacion,
        "comentario"  : newTrack.comentario
      },
      where: 'id = ?',
      whereArgs: [newTrack.id]
    );
    return res;
  }

  /**where: 'id_track = ?',
  //   whereArgs: ['${newGrade.idTrack}'] */

  // ==== Discos puntuados ====

  // Select disco puntuado.
  Future<List<DiscoPuntuado>> selectDiscosPuntuados(int limit) async {
    final db = await database;
    final res = await db.query(
      'discos_puntuados',
      orderBy: "CAST(puntuacion AS DOUBLE) DESC",
      limit: limit
    );
    List<DiscoPuntuado> list = res.isNotEmpty // Si la consulta no está vacía...
                                      ? res.map((e) => DiscoPuntuado.fromJson(e)).toList() // Devuelve la lista de respuestas.
                                      : []; // Devuelve una lista vacía.
    return list;
  }
  
  Future<List<DiscoPuntuado>> selectDiscosPuntuadosPorID(String idAlbum) async {
    final db = await database;
    final res = await db.query('discos_puntuados',
      where: 'id = ?',
      whereArgs: [idAlbum]
    );
    List<DiscoPuntuado> list = res.isNotEmpty // Si la consulta no está vacía...
                                  ? res.map((e) => DiscoPuntuado.fromJson(e)).toList() // Devuelve la lista de respuestas.
                                  : []; // Devuelve una lista vacía.
    return list;
  }

  insertDisco(DiscoPuntuado newDisk) async {
    final db = await database;
    final res = await db.insert('discos_puntuados', <String, dynamic> {
      "id"    : newDisk.id,
      "id_artista"  : newDisk.id_artista,
      "puntuacion"  : newDisk.puntuacion,
      "puesto_top"  : newDisk.puesto_top,
      "comentario"  : newDisk.comentario
    });
    return res;
  }

  updateDisco(DiscoPuntuado newDisk) async {
    final db = await database;
    final res = await db.update('discos_puntuados', <String, dynamic> {
        "id"    : newDisk.id,
        "id_artista"  : newDisk.id_artista,
        "puntuacion"  : newDisk.puntuacion,
        "puesto_top"  : newDisk.puesto_top,
        "comentario"  : newDisk.comentario
      },
      where: 'id = ?',
      whereArgs: [newDisk.id]
    );
    return res;
  }

  deleteDisco(String idDisk) async {
    final db = await database;
    final res = await db.delete(
      "discos_puntuados",
      where: "id = ?",
      whereArgs: [idDisk]
    );
    return res;
    // final res = await db.update('discos_puntuados', <String, dynamic> {
    //     "id"    : newDisk.id,
    //     "id_artista"  : newDisk.id_artista,
    //     "puntuacion"  : newDisk.puntuacion,
    //     "puesto_top"  : newDisk.puesto_top,
    //     "comentario"  : newDisk.comentario
    //   },
    //   where: 'id = ?',
    //   whereArgs: [newDisk.id]
    // );
  }

  // SELECT GRADE.
  // Future<List<Grade>> selectGradeByAlbum(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.query('grades',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   List<Grade> list = res.isNotEmpty // Si la consulta no está vacía...
  //                                     ? res.map((e) => Grade.fromJson(e)).toList() // Devuelve la lista de respuestas.
  //                                     : []; // Devuelve una lista vacía.
  //   return list;
  // }

  // // SELECT ALL GRADES.
  // Future<dynamic> selectAllGrades() async {
  //   final db = await database;
  //   final res = await db.query('grades');
  //   final list = res.isNotEmpty
  //                                   ? res.map((e) => Grade.fromJson(e)).toList()
  //                                   : [];
  //   return list;
  // }

  // // INSERT GRADE.
  // insertGrade(Grade newGrade) async {
  //   final db = await database;
  //   final res = await db.insert('grades', <String, dynamic> {
  //     "id_track" : newGrade.idTrack,
  //     "id_album" : newGrade.idAlbum,
  //     "grade"    : newGrade.grade,
  //     "comment"  : newGrade.comment
  //   });
  //   return res;
  // }

  // // UPDATE GRADE.
  // updateGrade(Grade newGrade) async {
  //   final db = await database;
  //   final res = await db.update('grades', <String, dynamic> {
  //     "id_album" : newGrade.idAlbum,
  //     "grade"    : newGrade.grade,
  //     "comment"  : newGrade.comment
  //   },
  //   where: 'id_track = ?',
  //   whereArgs: ['${newGrade.idTrack}']);

  //   return res;
  // }

  // // DELETE GRADE.
  // deleteGrade(String idTrack) async {
  //   final db = await database;
  //   final res = await db.delete('grades',
  //     where: 'id_track = ?',
  //     whereArgs: [idTrack]
  //   );
  //   return res;
  // }

  // // ==== DISCS ====

  // // SELECT DISC.
  // Future<List<Disc>> selectDisc(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.query('discs',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   List<Disc> list = res.isNotEmpty // Si la consulta no está vacía...
  //                                     ? res.map((e) => Disc.fromJson(e)).toList() // Devuelve la lista de respuestas.
  //                                     : []; // Devuelve una lista vacía.
  //   return list;
  // }

  // Future<List<Disc>> orderDiscs() async {
  //   final db = await database;
  //   final res = await db.rawQuery("select * from discs order by CAST(nota_media AS REAL) desc");
  //   // final res = await db.query('discs',
  //   //   orderBy: 'nota_media'
  //   // );
  //   List<Disc> list = res.isNotEmpty // Si la consulta no está vacía...
  //                                     ? res.map((e) => Disc.fromJson(e)).toList() // Devuelve la lista de respuestas.
  //                                     : []; // Devuelve una lista vacía.             
  //   int contador = 1;
  //   list.forEach((element) {
  //     updateDiscOrder(element.idAlbum, contador.toString());
  //     contador++;
  //   });
    
  //   return list;
  // }

  // Future<bool> checkIfDiscHaveBeenAlreadyRated(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.query('discs',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
    
  //   if(res.isNotEmpty) return true; // Si no está vacío, ya ha sido valorado.
  //   else return false; // Si está vacío, no ha sido valorado.
  // }

  // // SELECT ALL DISCS.
  // Future<List<Disc>> selectAllDiscs() async {
  //   final db = await database;
  //   final res = await db.query('discs');
  //   List<Disc> list = res.isNotEmpty
  //                                   ? res.map((e) => Disc.fromJson(e)).toList()
  //                                   : [];
  //   return list;
  // }

  // // INSERT DISC.
  // insertDisc(String idAlbum, String notaMedia) async {
  //   final db = await database;
  //   final res = await db.insert('discs', <String, dynamic> {
  //     "id_album"   : idAlbum,
  //     "nota_media" : notaMedia
  //   });
  //   print("Se guarda el disco.");
  //   return res;
  // }

  // // UPDATE DISC.
  // updateDisc(String idAlbum, String notaMedia) async {
  //   final db = await database;
  //   final res = await db.update('discs', <String, dynamic> {
  //       "id_album"   : idAlbum,
  //       "nota_media" : notaMedia
  //     },
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   print("Se actualiza el disco.");
  //   return res;
  // }

  // // UPDATE DISC.
  // updateDiscOrder(String idAlbum, String orden) async {
  //   final db = await database;
  //   final res = await db.update('discs', <String, dynamic> {
  //       "orden": orden
  //     },
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   print("Se actualiza el orden de álbum $idAlbum ($orden). $res");
  //   return res;
  // }

  // // DELETE DISC.
  // deleteDisc(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.delete('discs',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   return res;
  // }

  // // ============ SAVED ============

  // // SELECT GRADE.
  // checkOneSaved(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.query('saved',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   return res.isNotEmpty ? true : false ;
  // }

  // Future<List<Saved>> selectAllSaved() async {
  //   final db = await database;
  //   final res = await db.query('saved');
  //   List<Saved> list = res.isNotEmpty
  //                                   ? res.map((e) => Saved.fromJson(e)).toList()
  //                                   : [];
  //   return list;
  // }

  // // INSERT GRADE.
  // insertSaved(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.insert('saved', <String, dynamic> {
  //     "id_album" : idAlbum
  //   });
  //   return res;
  // }

  // // DELETE GRADE.
  // deleteSaved(String idAlbum) async {
  //   final db = await database;
  //   final res = await db.delete('saved',
  //     where: 'id_album = ?',
  //     whereArgs: [idAlbum]
  //   );
  //   return res;
  // }

}