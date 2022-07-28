import 'package:flutter_test/flutter_test.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/repository/list_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_repository_test.mocks.dart';

@GenerateMocks([ApplicationDatabase, PreferenceWrapper])
void main() {
  test("getRestaurantsTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = ListRepository(database, wrapper);
    when(wrapper.getSortSelection()).thenReturn(SortOptions.cityAscending);
    final cityFilters = <String>{};
    when(wrapper.getCityFilters()).thenReturn(cityFilters);
    final returnList = [
      Restaurant(
          id: "id",
          name: "Test Restaurant",
          desc: "Test Description",
          lat: 1.0,
          lon: 1.0,
          year: 2022,
          address: "Test Address",
          district: "Test District",
          city: "Test City",
          country: "Test Country",
          tel: "1234567",
          rating: 5.0,
          logo: "Test Logo",
          distance: 0.0)
    ];
    when(database.getRestaurants(cityFilters, SortOptions.cityAscending, ""))
        .thenAnswer((_) => Future.value(returnList));
    var result = await repository.getRestaurants();
    assert(returnList == result, "");
  });

  test("registerListenerTest", () {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = ListRepository(database, wrapper);
    listener() => {};
    repository.registerSettingsChangeListener(listener);
    verify(wrapper.addListener(listener)).called(1);
  });

  test("unregisterListenerTest", () {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final repository = ListRepository(database, wrapper);
    listener() => {};
    repository.unregisterSettingsChangeListener(listener);
    verify(wrapper.removeListener(listener)).called(1);
  });
}
