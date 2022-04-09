import 'package:sqflite/sqflite.dart';

class NotificationData {
  int id;
  String title;
  String content;
  int frequency;
  int time;
  int setAlarm; // 0(false):アラームを設定しない, 1(true):設定する

  NotificationData(
    this.id,
    this.title,
    this.content,
    this.frequency,
    this.time,
    this.setAlarm,
  );
}

class NotificationsTable {
  static String tableName = "notifications";

  Future<Database?> _opendb() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = "$databasesPath/notifications.db";

      var db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT not null,
          title TEXT not null,
          content TEXT,
          frequency INTEGER,
          time INTEGER not null,
          set_alarm INTEGER not null
        )''');
      });
      return db;
    } catch (e) {
      assert(() {
        print(e);
        return true;
      }());
      return null;
    }
  }

  Future<List<Map>?> select({
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      var db = await _opendb();
      var dataList = await db?.query(tableName,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);
      await db?.close();
      return dataList;
    } catch (e) {
      assert(() {
        print(e);
        return true;
      }());
      return null;
    }
  }

  Future<int?> insert(
    String title,
    String content,
    int frequency,
    int time,
    int setAlarm,
  ) async {
    try {
      var db = await _opendb();
      int? id = await db?.rawInsert(
        'INSERT INTO $tableName (title, content, frequency, time, set_alarm) VALUES (?, ?, ?, ?, ?)',
        [title, content, frequency, time, setAlarm],
      );
      await db?.close();
      return id;
    } catch (e) {
      assert(() {
        print(e);
        return true;
      }());
      return null;
    }
  }

  Future<int?> update(
    int id,
    String title,
    String content,
    int frequency,
    int time,
    int setAlarm,
  ) async {
    try {
      var db = await _opendb();
      var numOfChanged = await db?.rawUpdate(
        'UPDATE $tableName SET title = ?, content = ?, frequency = ?, time = ?, set_alarm = ? WHERE id = ?',
        [title, content, frequency, time, setAlarm, id],
      );
      await db?.close();
      return numOfChanged;
    } catch (e) {
      assert(() {
        print(e);
        return true;
      }());
      return null;
    }
  }

  Future<int?> delete(int id) async {
    try {
      var db = await _opendb();
      var numOfChanged = await db?.rawDelete(
        'DELETE FROM $tableName WHERE id = ?',
        [id],
      );
      await db?.close();
      return numOfChanged;
    } catch (e) {
      assert(() {
        print(e);
        return true;
      }());
      return null;
    }
  }
}
