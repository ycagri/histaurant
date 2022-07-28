import 'package:flutter_test/flutter_test.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/repository/settings_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ApplicationDatabase>(returnNullOnMissingStub: true),
  MockSpec<PreferenceWrapper>(returnNullOnMissingStub: true)
])
void main() {
  test("getSortOptionTest", () {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = SettingsRepository(database, wrapper);
    when(wrapper.getSortSelection()).thenReturn(SortOptions.cityAscending);
    assert(repository.getSortOption() == SortOptions.cityAscending);
  });

  test("getCityFiltersTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = SettingsRepository(database, wrapper);
    when(database.getCities())
        .thenAnswer((_) => Future.value(<String>["city1", "city2", "city3"]));
    when(wrapper.getCityFilters()).thenReturn(<String>{"city1", "city2"});
    var filters = await repository.getCityFilters();
    assert(filters["city1"] == true);
    assert(filters["city2"] == true);
    assert(filters["city3"] == false);
    assert(filters["city4"] == null);
  });

  test("addCityFilterTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = SettingsRepository(database, wrapper);
    when(wrapper.getCityFilters()).thenReturn(<String>{"city1", "city2"});
    repository.addOrRemoveCityFilter("city3");
    verify(wrapper.addCityFilter("city3"));
  });

  test("removeCityFilterTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = SettingsRepository(database, wrapper);
    when(wrapper.getCityFilters()).thenReturn(<String>{"city1", "city2"});
    repository.addOrRemoveCityFilter("city2");
    verify(wrapper.removeCityFilter("city2"));
  });
}
