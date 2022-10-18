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

  Future<List<Restaurant>> getRestaurants(
      Set<String> cityFilters, SortOptions option) async {
    List<Restaurant> restaurants = <Restaurant>[];
    List<Map<String, dynamic>> result;
    String orderBy = _getSortColumn(option);
    if (cityFilters.isNotEmpty) {
      var params = List.filled(cityFilters.length, "?");
      var whereClause = "city IN(${params.join(",")})";
      result = await _database.query("tbl_restaurants",
          where: whereClause,
          whereArgs: cityFilters.toList(),
          orderBy: orderBy);
    } else {
      result = await _database.query("tbl_restaurants", orderBy: orderBy);
    }

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

  String _getSortColumn(SortOptions sortOption) {
    String option = "";
    switch (sortOption) {
      case SortOptions.alphabeticallyDescending:
        option = "name Desc";
        break;
      case SortOptions.alphabeticallyAscending:
        option = "name Asc";
        break;
      case SortOptions.cityDescending:
        option = "city Desc";
        break;
      case SortOptions.cityAscending:
        option = "city Asc";
        break;
      case SortOptions.distanceDescending:
        option = "distance Desc";
        break;
      case SortOptions.distanceAscending:
        option = "distance Asc";
        break;
      case SortOptions.dateAscending:
        option = "year Asc";
        break;
      case SortOptions.dateDescending:
        option = "year Desc";
        break;
    }
    return option;
  }
}