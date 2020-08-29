import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String taskTable = "task_table";
  String colid = "id";
  String colTitle = "title";
  String colDate = "date";
  String colPriority = "priority";
  String colStatus = "status";

  //Task table
//id | title | date | priority | status
//0     " "      " "   " "        0
//1     " "      " "   " "        0
//2     " "      " "   " "        0

  Future<Database> get db async {
    if (_db == null) {
      _db = await initdb();
    }
    return _db;
  }

  Future<Database> initdb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/todo_list.db';
    final todoListdb =
        await openDatabase(path, version: 1, onCreate: _createdb);
    return todoListdb;
  }

  void _createdb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $taskTable($colid INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskB.date.compareTo(taskA.date));
    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(taskTable, task.toMap(),
        where: '$colid = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(taskTable, where: '$colid = ?', whereArgs: [id]);
    return result;
  }
}
