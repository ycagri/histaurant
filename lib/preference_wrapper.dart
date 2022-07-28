import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortOptions {
  alphabeticallyAscending,
  alphabeticallyDescending,
  cityAscending,
  cityDescending,
  distanceAscending,
  distanceDescending,
  dateAscending,
  dateDescending
}

@singleton
@injectable
class PreferenceWrapper extends ChangeNotifier {
  static const _sortOptionKey = "sort_option";

  static const _cityFiltersKey = "city_filter";

  final SharedPreferences _sharedPreferences;

  PreferenceWrapper(this._sharedPreferences);

  void setSortSelection(SortOptions option) {
    _sharedPreferences.setInt(_sortOptionKey, option.index);
    notifyListeners();
  }

  SortOptions getSortSelection() {
    var index = _sharedPreferences.getInt(_sortOptionKey) ??
        SortOptions.distanceAscending.index;
    return SortOptions.values[index];
  }

  void addCityFilter(String city) {
    var filterList =
        _sharedPreferences.getStringList(_cityFiltersKey) ?? <String>[];
    filterList.add(city);
    _sharedPreferences.setStringList(_cityFiltersKey, filterList);
    notifyListeners();
  }

  void removeCityFilter(String city) {
    var filterList =
        _sharedPreferences.getStringList(_cityFiltersKey) ?? <String>[];
    filterList.removeWhere((e) => e == city);
    _sharedPreferences.setStringList(_cityFiltersKey, filterList);
    notifyListeners();
  }

  Set<String> getCityFilters() {
    var filterList =
        _sharedPreferences.getStringList(_cityFiltersKey) ?? <String>[];
    return filterList.toSet();
  }
}
