import 'package:historical_restaurants/database/restaurant.dart';
import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import '../preference_wrapper.dart';

@injectable
class ListRepository {
  final ApplicationDatabase _database;

  final PreferenceWrapper _wrapper;

  ListRepository(this._database, this._wrapper);

  Future<List<Restaurant>> getRestaurants() => _database.getRestaurants(
      _wrapper.getCityFilters(), _wrapper.getSortSelection(), "");

  void registerSettingsChangeListener(Function() listener) {
    _wrapper.addListener(listener);
  }

  void unregisterSettingsChangeListener(Function() listener) {
    _wrapper.removeListener(listener);
  }
}
