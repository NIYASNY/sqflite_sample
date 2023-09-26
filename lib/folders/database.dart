// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static Future<Database> _firstDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, 'mydatabase');
//     return openDatabase(path, version: 1, onCreate: _createdatabase);
//   }

//   static Future<void> _createdatabase(Database db, int version) async {
//     await db.execute('');
//   }

//   static Future<int> interUser(String name, int age) async {
//     final db = await _firstDatabase();
//     final data = {
//       'name': name,
//       'age': age,
//     };
//     return await db.insert('users', data);
//   }

//   static Future<List<Map<String, dynamic>>> getData() async {
//     final db = await _firstDatabase();
//     return await db.query('users');
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _opendatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(""" 
    CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER
    )
    """);
  }

  static Future<int> insertUser(String name, int age) async {
    final db = await _opendatabase();
    final data = {
      "name": name,
      "age": age,
    };
    return await db.insert('users', data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _opendatabase();
    return await db.query('users');
  }

  static Future<int> deleteData(int id) async {
    final db = await _opendatabase();
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

    static Future<Map<String, dynamic>?> getSingleData(int id) async {
      final db = await _opendatabase();
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> UpdateData(int id, Map<String, dynamic> data) async {
    final db = await _opendatabase();
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }
}
