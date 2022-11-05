import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ApplicationDatabase {
  final Database _database;

  ApplicationDatabase(this._database);

  static Future<ApplicationDatabase> create() async {
    return ApplicationDatabase(
        await openDatabase(join(await getDatabasesPath(), 'app_database.db'),
            onCreate: (db, version) {
      return db.execute(
          "Create Table If Not Exists tbl_restaurants(id TEXT PRIMARY KEY NOT NULL, name TEXT, desc TEXT, lat REAL, lon REAL, year INTEGER, address TEXT, district TEXT, city TEXT, country TEXT, tel TEXT, rating REAL, logo TEXT, distance REAL);");
    }, version: 1));
  }

  Future<void> insertRestaurants(List<Restaurant> restaurants) async {
    var batch = _database.batch();
    for (var restaurant in restaurants) {
      batch.insert("tbl_restaurants", restaurant.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Restaurant>> getRestaurants() async {
    List<Restaurant> restaurants = <Restaurant>[];
    List<Map<String, dynamic>> result = await _database.query("tbl_restaurants", orderBy: "name");
    for (var r in result) {
      restaurants.add(Restaurant.fromJson(r));
    }

    return restaurants;
  }

  Future<List<String>> getCities() async {
    List<String> cities = <String>[];
    var result = await _database.query("tbl_restaurants",
        columns: <String>["city"], distinct: true, orderBy: "city");
    for (var r in result) {
      cities.add(r["city"].toString());
    }
    return cities;
  }
}