import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _db = new DbHelper._internal();
  DbHelper._internal();
  static DbHelper get instance => _db;
  static Database? _database;

  Future<Database> get database async {
    if (_database == null){ 
      _database = await _init();
    }
    return _database!;
  }

  Future<Database> _init() async {
    var dbPath = await getApplicationDocumentsDirectory();
    print("DB path $dbPath");
    return openDatabase(join(dbPath.path, "school.db"), version: 1,
        onConfigure: (db) {
      print("Configure DB");
    }, onCreate: (db, version) {
      print("Create DB");
    }, onOpen: (db) async {
      print("Open DB");
      await db.execute(
          'CREATE TABLE IF NOT EXISTS student (id INTEGER PRIMARY KEY,name TEXT,age INTEGER)');
    });
  }

  Future<List<Map<String, dynamic>>> getAllRows(String tblName) async {
    return _database!.query(tblName);
  }

  Future<int> insertRow(String tblName, Map<String, dynamic> data) {
    return _database!.insert(tblName, data);
  }

  Future<int> updateRow(String tblName, Map<String, dynamic> data,
      String condition, List<Object> args) {
    return _database!.update(tblName, data, where: condition, whereArgs: args);
  }

  Future<int> deleteRow(String tblName, String condition, List<Object> args) {
    return _database!.delete(tblName, where: condition, whereArgs: args);
  }
}
