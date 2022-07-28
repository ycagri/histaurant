import 'package:injectable/injectable.dart';

import '../database/app_database.dart';
import '../preference_wrapper.dart';

@injectable
class SettingsRepository {
  final ApplicationDatabase _database;

  final PreferenceWrapper _wrapper;

  SettingsRepository(this._database, this._wrapper);

  Future<Map<String, bool>> getCityFilters() async {
    var filters = _wrapper.getCityFilters();
    var cities = await _database.getCities();
    return {for (var item in cities) item: filters.contains(item)};
  }

  void addOrRemoveCityFilter(String city) {
    var filters = _wrapper.getCityFilters();
    if (filters.contains(city)) {
      _wrapper.removeCityFilter(city);
    } else {
      _wrapper.addCityFilter(city);
    }
  }

  SortOptions getSortOption() => _wrapper.getSortSelection();

  void setSortOption(SortOptions option) => _wrapper.setSortSelection(option);
}
