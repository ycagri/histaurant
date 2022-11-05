import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/api/rest_api.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:historical_restaurants/utils/LocationHelper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<ApplicationDatabase>(onMissingStub: OnMissingStub.returnDefault),
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
  var restApi = MockRestApi();

  var cameraPosition = const CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  var defaultCameraPosition =
      const CameraPosition(target: LatLng(39.925533, 32.866287), zoom: 4);
  var localRestaurants = _generateTestRestaurantList(5);
  var remoteRestaurants = _generateTestRestaurantList(10);

  blocTest("mapCubitGetPositionTest",
      build: () {
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants())
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        return MapCubit(
            applicationDatabase, locationHelper, restApi);
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
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.error("Error"));
        when(applicationDatabase.getRestaurants())
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        return MapCubit(
            applicationDatabase, locationHelper, restApi);
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
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants())
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants()).thenAnswer((_) => Future.error("Error"));
        return MapCubit(
            applicationDatabase, locationHelper, restApi);
      },
      expect: () => [
            MapRestaurantsLoadedState(localRestaurants),
            MapPositionLoadedState(cameraPosition)
          ],
      verify: (_) =>
          {applicationDatabase.insertRestaurants(remoteRestaurants)});

  blocTest("mapCubitGetLocalRestaurantsTest",
      build: () {
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants())
            .thenAnswer((_) => Future.error("Error"));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        return MapCubit(
            applicationDatabase, locationHelper, restApi);
      },
      expect: () => [
            MapRestaurantsLoadedState(remoteRestaurants),
            MapPositionLoadedState(cameraPosition)
          ],
      verify: (_) =>
          {applicationDatabase.insertRestaurants(remoteRestaurants)});

  blocTest("mapCubitNavigateRestaurantsTest",
      build: () {
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        when(applicationDatabase.getRestaurants())
            .thenAnswer((_) => Future.value(localRestaurants));
        when(restApi.getRestaurants())
            .thenAnswer((_) => Future.value(remoteRestaurants));
        return MapCubit(
            applicationDatabase, locationHelper, restApi);
      },
      act: (MapCubit cubit) => cubit.navigateToRestaurant(const Restaurant(
          id: "test_id",
          name: "Test Restaurant",
          desc: "Description",
          lat: 0.0,
          lon: 0.0,
          year: 2022,
          address: "Address",
          district: "District",
          city: "City",
          country: "Country",
          tel: "0000000",
          rating: 5.0,
          logo: "logo")),
      expect: () => [
            MapNavigateRestaurantState("test_id",
                const CameraPosition(target: LatLng(0.0, 0.0), zoom: 10)),
            MapRestaurantsLoadedState(localRestaurants),
            MapRestaurantsLoadedState(remoteRestaurants),
            MapPositionLoadedState(cameraPosition)
          ],
      verify: (_) =>
          {applicationDatabase.insertRestaurants(remoteRestaurants)});
}
