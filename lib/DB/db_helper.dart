import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather_app/Controllers/weather_controller.dart';

class DBHelper {
  Database? database;
  int DB_VERSION = 1;
  String TABLE_NAME = 'Cities';
  String COLUMN_NAME = 'name';

  Future<Database> get getDb async {
    if (database != null) {
      return database!;
    } else {
      database = await initializeDB('weather.db');
      return database!;
    }
  }

  Future<Database> initializeDB(String dbname) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, dbname);
    return await openDatabase(path, version: DB_VERSION, onCreate: createDB);
  }

  Future<void> createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE_NAME($COLUMN_NAME TEXT NOT NULL)');
  }

  Future<int> storeCitiesLocally(List<String> dataToStore) async {
    final db = await getDb;
    final bool isTableEmpty = await checkIfCitiesTableEmpty();
    if (!isTableEmpty) {
      db.delete(TABLE_NAME);
    }
    try {
      Batch batch = db.batch();
      for (final city in dataToStore) {
        batch.insert(TABLE_NAME, {COLUMN_NAME: city});
      }
      await batch.commit(noResult: true);
      return 200;
    } catch (e) {
      print('Error while storing city names: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getCitiesByName(String search) async {
    final db = await getDb;
    print(search);
    try {
      List<Map<String, dynamic>> qResult = await db.query(TABLE_NAME,
          where: '$COLUMN_NAME Like ?', whereArgs: ['%$search%']);
      print(qResult);
      return qResult;
    } catch (e) {
      print('Error while getting cities by name: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllCities() async {
    final db = await getDb;
    try {
      return await db.query(TABLE_NAME);
    } catch (e) {
      print('Error while reading all cities names: $e');
      return [];
    }
  }

  Future<bool> checkIfCitiesTableEmpty() async {
    final db = await getDb;
    List qResult = await db.query(TABLE_NAME);

    return qResult.isEmpty;
    //
    // }
  }
}