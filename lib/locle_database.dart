
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_demo/sqlite_model.dart';

class LocalDatabase {
  static String userdatabase = 'UserDatabase.Db';
  static String userMSt = 'User_MSt';

  static Future<Database> get _openDB async {
    return await openDatabase(
      join(await getDatabasesPath(), userdatabase),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
            'CREATE TABLE $userMSt(id INTEGER PRIMARY KEY, userName TEXT )');
      },
    );
  }

  static Future<void> insertData({required User user}) async {
    var db = await _openDB;
    await db.insert(userMSt, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<User>> selectData() async {
    var db = await _openDB;
    List<Map<String, dynamic>> data = await db.query(userMSt);
    return List.generate(
      data.length,
      (index) => User.fromJson(
        data[index],
      ),
    );
  }

  static Future<void> updateData(User user) async {
    var db = await _openDB;
    db.update(userMSt, user.toJson(), where: 'id=?', whereArgs: [user.id]);
  }

  static Future<void> deleteData(int id) async {
    var db = await _openDB;
    await db.delete(userMSt, where: 'id=?', whereArgs: [id]);
  }
}
