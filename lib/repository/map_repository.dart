import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import '../database/restaurant.dart';
import '../preference_wrapper.dart';
import '../utils/LocationHelper.dart';

@injectable
class MapRepository {
  final ApplicationDatabase _database;

  final PreferenceWrapper _wrapper;

  final LocationHelper _locationHelper;

  MapRepository(this._database, this._wrapper, this._locationHelper);

  Future<Position> getUserLocation() {
    return _locationHelper.getUserLocation();
  }

  Future<List<Restaurant>> getRestaurants() async {
    try {
      await _getRestaurantsFromRemote();
      return await _getRestaurantsFromLocal();
    } catch (e) {
      return await _getRestaurantsFromLocal();
    }
  }

  Future<List<Restaurant>> getRestaurantsFromLocal() =>
      _getRestaurantsFromLocal();

  void registerSettingsChangeListener(Function() listener) {
    _wrapper.addListener(listener);
  }

  void unregisterSettingsChangeListener(Function() listener) {
    _wrapper.removeListener(listener);
  }

  Future<void> _getRestaurantsFromRemote() async {
    String res = await rootBundle.loadString('assets/response.json');
    List<dynamic> response = jsonDecode(res);
    await _determineDistance(response);
    List<Restaurant> restaurants = <Restaurant>[];
    for (var r in response) {
      restaurants.add(Restaurant.fromJson(r));
    }
    await _database.insertRestaurants(restaurants);
    _getRestaurantsFromLocal();
  }

  Future<List<Restaurant>> _getRestaurantsFromLocal(
      {String searchTerm = ""}) async {
    return _database.getRestaurants(
        _wrapper.getCityFilters(), _wrapper.getSortSelection(), searchTerm);
  }

  Future<List<dynamic>> _determineDistance(List<dynamic> restaurants) async {
    Position location = await _locationHelper.getUserLocation();
    for (var restaurant in restaurants) {
      restaurant["distance"] = _calculateDistance(location.latitude,
          location.longitude, restaurant["lat"], restaurant["lon"]);
    }
    return restaurants;
  }

  double _calculateDistance(
      double userLat, double userLon, double restLat, double restLon) {
    const R = 6371e3; // metres
    double userLatRadians = userLat * pi / 180;
    double restLatRadians = restLat * pi / 180;
    double deltaLatRadians = (restLat - userLat) * pi / 180;
    double deltaLonRadians = (restLon - userLon) * pi / 180;

    double a = sin(deltaLatRadians / 2) * sin(deltaLatRadians / 2) +
        cos(userLatRadians) *
            cos(restLatRadians) *
            sin(deltaLonRadians / 2) *
            sin(deltaLonRadians / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c / 1000;
  }
}
