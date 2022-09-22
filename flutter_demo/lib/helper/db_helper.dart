import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../model/user.dart';

class DBHelper {
  static const String tableUser = "user";
  static const String fieldId = "id";
  static const String fieldName = "name";
  static const String fieldAge = "age";

  static DBHelper? _dbHelper;
  static sql.Database? _db;

  DBHelper();

  factory DBHelper.getInstance() {
    _dbHelper ??= DBHelper();
    return _dbHelper!;
  }

  Future<void> updateUser(User user) async {
    _db ??= await _getDB();
    _db?.update(
        tableUser,
        {
          fieldName: user.username,
          fieldAge: user.age,
        },
        where: "$fieldId=?",
        whereArgs: [user.id]);
  }

  Future<void> insertUser(String name, int age) async {
    _db ??= await _getDB();
    await _db?.insert(
        tableUser,
        {
          fieldName: name,
          fieldAge: age,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> deleteUser(int userId) async {
    _db ??= await _getDB();
    await _db?.delete(tableUser, where: "$fieldId=?", whereArgs: [userId]);
  }

  Future<void> deleteAllUsers() async {
    _db ??= await _getDB();
    await _db?.delete(tableUser);
  }

  Future<List<User>> getUsers() async {
    _db ??= await _getDB();

    List<Map<String, dynamic>> result = await _db!.query(tableUser);

    List<User> users = [];

    if (result.isNotEmpty) {
      for (Map<String, dynamic> data in result) {
        users.add(User(
            id: data[fieldId] as int,
            username: data[fieldName] as String,
            age: data[fieldAge] as int));
      }
    }

    return users;
  }

  Future<List<User>> filterUsers(int age) async {
    _db ??= await _getDB();

    List<Map<String, dynamic>> result =
        await _db!.query(tableUser, where: "$fieldAge<=?", whereArgs: [age]);

    List<User> users = [];

    if (result.isNotEmpty) {
      for (Map<String, dynamic> data in result) {
        users.add(User(
            id: data[fieldId] as int,
            username: data[fieldName] as String,
            age: data[fieldAge] as int));
      }
    }

    return users;
  }

  static Future<sql.Database> _getDB() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase("$dbPath/flutterdemo.db", onCreate: (db, version) {
      debugPrint("onCreate db: $version");
      // create user table
      String userSQL =
          "CREATE TABLE $tableUser ($fieldId INTEGER PRIMARY KEY AUTOINCREMENT";
      userSQL += ", $fieldName VARCHAR(150)";
      userSQL += ", $fieldAge INTEGER DEFAULT 0)";

      db.execute(userSQL);
    }, onUpgrade: (db, oldVersion, newVersion) {
      debugPrint("$oldVersion $newVersion");
    }, version: 4);
  }
}
