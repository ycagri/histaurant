import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/api/rest_api.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:historical_restaurants/utils/LocationHelper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ApplicationDatabase>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PreferenceWrapper>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<LocationHelper>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<RestApi>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  List<Restaurant> _generateTestRestaurantList(int count) {
    List<Restaurant> restaurants = <Restaurant>[];
    for (var i = 1; i <= count; i++) {
      restaurants.add(Restaurant(
          id: "id_$i",
          name: "Test Restaurant $i",
          desc: "Test Description $i",
          lat: 1.0,
          lon: 1.0,
          year: 2022,
          address: "Test Address",
          district: "Test District",
          city: "Test City",
          country: "Test Country",
          tel: "1234567",
          rating: 5.0,
          logo: "Test Logo"));
    }
    return restaurants;
  }

  Position _createMockPosition() => Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  var applicationDatabase = MockApplicationDatabase();
  var locationHelper = MockLocationHelper();
  var preferenceWrapper = MockPreferenceWrapper();
  var restApi = MockRestApi();

  var cameraPosition = const CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  var defaultCameraPosition = const CameraPosition(target: LatLng(39.925533, 32.866287), zoom: 4);
  var localRestaurants = _generateTestRestaurantList(5);
  var remoteRestaurants = _generateTestRestaurantList(10);

  blocTest("mapCubitGetPositionTest",
      build: () {
        var filters = <String>{};
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants(
                filters, SortOptions.alphabeticallyAscending))
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        when(preferenceWrapper.getCityFilters()).thenAnswer((_) => filters);
        when(preferenceWrapper.getSortSelection())
            .thenAnswer((_) => SortOptions.alphabeticallyAscending);
        return MapCubit(
            applicationDatabase, preferenceWrapper, locationHelper, restApi);
      },
      expect: () => [
            MapRestaurantsLoadedState(localRestaurants),
            MapRestaurantsLoadedState(remoteRestaurants),
            MapPositionLoadedState(cameraPosition)
          ],
      verify: (_) =>
          {applicationDatabase.insertRestaurants(remoteRestaurants)});

  blocTest("mapCubitGetPositionFailTest",
      build: () {
        var filters = <String>{};
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.error("Error"));
        when(applicationDatabase.getRestaurants(
            filters, SortOptions.alphabeticallyAscending))
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        when(preferenceWrapper.getCityFilters()).thenAnswer((_) => filters);
        when(preferenceWrapper.getSortSelection())
            .thenAnswer((_) => SortOptions.alphabeticallyAscending);
        return MapCubit(
            applicationDatabase, preferenceWrapper, locationHelper, restApi);
      },
      expect: () => [
        MapRestaurantsLoadedState(localRestaurants),
        MapRestaurantsLoadedState(remoteRestaurants),
        MapPositionLoadedState(defaultCameraPosition)
      ],
      verify: (_) =>
      {applicationDatabase.insertRestaurants(remoteRestaurants)});

  blocTest("mapCubitGetRemoteRestaurantsFailTest",
      build: () {
        var filters = <String>{};
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants(
            filters, SortOptions.alphabeticallyAscending))
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.error("Error"));
        when(preferenceWrapper.getCityFilters()).thenAnswer((_) => filters);
        when(preferenceWrapper.getSortSelection())
            .thenAnswer((_) => SortOptions.alphabeticallyAscending);
        return MapCubit(
            applicationDatabase, preferenceWrapper, locationHelper, restApi);
      },
      expect: () => [
        MapRestaurantsLoadedState(localRestaurants),
        MapPositionLoadedState(cameraPosition)
      ],
      verify: (_) =>
      {applicationDatabase.insertRestaurants(remoteRestaurants)});

  blocTest("mapCubitGetLocalRestaurantsTest",
      build: () {
        var filters = <String>{};
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants(
            filters, SortOptions.alphabeticallyAscending))
            .thenAnswer((_) => Future.error("Error"));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        when(preferenceWrapper.getCityFilters()).thenAnswer((_) => filters);
        when(preferenceWrapper.getSortSelection())
            .thenAnswer((_) => SortOptions.alphabeticallyAscending);
        return MapCubit(
            applicationDatabase, preferenceWrapper, locationHelper, restApi);
      },
      expect: () => [
        MapRestaurantsLoadedState(remoteRestaurants),
        MapPositionLoadedState(cameraPosition)
      ],
      verify: (_) =>
      {applicationDatabase.insertRestaurants(remoteRestaurants)});
}
