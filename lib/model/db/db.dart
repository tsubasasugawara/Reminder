// ignore_for_file: avoid_print
import 'package:sqflite/sqflite.dart';

class NotificationsTable {
  int version = 2;

  static String tableName = "notifications";
  static const idKey = "id";
  static const titleKey = "title";
  static const contentKey = "content";
  static const frequencyKey = "frequency";
  static const timeKey = "time";
  static const setAlarmKey = "set_alarm"; // 0:off, 1:on
  static const deletedKey = "deleted"; // 0:not deleted, 1:in the trash can

  Future<Database?> _opendb() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = "$databasesPath/notifications.db";

      var db = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT not null,
              title TEXT not null,
              content TEXT,
              frequency INTEGER,
              time INTEGER not null,
              set_alarm INTEGER not null,
              deleted INTEGER not null DEFAULT 0)
          ''');
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion >= newVersion) return;

          if (oldVersion == 1) {
            await db.execute('''
              ALTER TABLE $tableName ADD COLUMN deleted INTEGER not null DEFAULT 0;
              ''');
          }
        },
      );
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
    Map<String, Object?> values,
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  ) async {
    try {
      var db = await _opendb();
      var numOfChanged = await db?.update(
        tableName,
        values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
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

  Future<int?> multipleDelete(List<int> ids) async {
    if (ids.isEmpty) return null;
    try {
      var db = await _opendb();

      String statement = ' DELETE FROM $tableName';

      statement = statement + ' WHERE id IN(?';
      for (int i = 1; i < ids.length; i++) {
        statement = statement + ',?';
      }
      statement = statement + ')';

      var numOfChanged = await db?.rawDelete(
        statement,
        ids,
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
