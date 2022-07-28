import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/repository/map_repository.dart';
import 'package:historical_restaurants/utils/LocationHelper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_repoository_test.mocks.dart';

@GenerateMocks([ApplicationDatabase, LocationHelper],
    customMocks: [MockSpec<PreferenceWrapper>(returnNullOnMissingStub: true)])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Position _createMockPosition() => Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  test("getRestaurantsTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final locationHelper = MockLocationHelper();
    final repository = MapRepository(database, wrapper, locationHelper);
    when(locationHelper.getUserLocation())
        .thenAnswer((_) => Future.value(_createMockPosition()));
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
    expect(102,
        verify(database.insertRestaurants(captureAny)).captured.first.length);
    verify(locationHelper.getUserLocation()).called(1);
    assert(returnList == result);
  });

  test("getUserLocationTest", () async {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final locationHelper = MockLocationHelper();
    final repository = MapRepository(database, wrapper, locationHelper);
    var pos = _createMockPosition();
    when(locationHelper.getUserLocation()).thenAnswer((_) => Future.value(pos));
    var res = await repository.getUserLocation();
    assert(pos == res);
  });

  test("registerListenerTest", () {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final locationHelper = MockLocationHelper();
    final repository = MapRepository(database, wrapper, locationHelper);
    listener() => {};
    repository.registerSettingsChangeListener(listener);
    verify(wrapper.addListener(listener)).called(1);
  });

  test("unregisterListenerTest", () {
    final database = MockApplicationDatabase();
    final wrapper = MockPreferenceWrapper();
    final locationHelper = MockLocationHelper();
    final repository = MapRepository(database, wrapper, locationHelper);
    listener() => {};
    repository.unregisterSettingsChangeListener(listener);
    verify(wrapper.removeListener(listener)).called(1);
  });
}
