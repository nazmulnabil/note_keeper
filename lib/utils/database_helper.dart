import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'Priority';
  String colDate = 'date';

  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }

    return _databaseHelper;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,  '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT )');
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

//Fetch

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = db.query(noteTable, orderBy: '$colPriority ASC');

    return result;
  }

//Insert

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    db.insert(noteTable, note.toMap());
  }

//Update

  Future<int> UpdateNote(Note note) async {
    Database db = await this.database;
    db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
  }

//Delete

  Future<int> DeleteNote(int id) async {
    Database db = await this.database;
    db.rawDelete('DELETE FROM  $noteTable WHERE $colId = $id');
  }

//Get number of Note  objects in database

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> a =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
  }


//getting notelist
      Future<List<Note>>   getNoteList() async{
        var noteMapList=await getNoteMapList();
        int count=noteMapList.length;
        int i;
        List<Note> notelist=[];


        for( i=0;i<count;i++){

          notelist.add(Note.fromMapObject(noteMapList[i]));



        }


        return notelist;

  }
}
