import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/repository/map_repository.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<MapRepository>(returnNullOnMissingStub: true),
  MockSpec<GoogleMapController>(returnNullOnMissingStub: true)
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
          logo: "Test Logo",
          distance: 0.0));
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

  var position = _createMockPosition();
  var restaurants = _generateTestRestaurantList(10);
  final repository = MockMapRepository();
  final mapController = MockGoogleMapController();

  blocTest("mapCubitGetRestaurantsTest",
      build: () {
        when(repository.getRestaurants())
            .thenAnswer((_) => Future.value(restaurants));
        when(repository.getRestaurantsFromLocal())
            .thenAnswer((_) => Future.value(restaurants));

        return MapCubit(repository);
      },
      act: (MapCubit cubit) => cubit.getRestaurants(),
      expect: () => [MapRestaurantsLoadedState(restaurants)],
      tearDown: () => verify(
          repository.unregisterSettingsChangeListener(argThat(isNotNull))));

  blocTest("mapCubitSetMapControllerTest",
      build: () {
        when(repository.getUserLocation())
            .thenAnswer((_) => Future.value(position));
        return MapCubit(repository);
      },
      act: (MapCubit cubit) => cubit.setMapController(mapController),
      tearDown: () =>
          verify(mapController.animateCamera(argThat(isNotNull))).called(1));
}
