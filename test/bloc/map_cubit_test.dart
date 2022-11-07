import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:historical_restaurants/utils/LocationHelper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_cubit_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<LocationHelper>(onMissingStub: OnMissingStub.returnDefault)
])
Future<void> main() async {
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

  List<Map<String, dynamic>> _generateTestResponse(int count){
    List<Map<String,dynamic>> response = <Map<String,dynamic>>[];
    for (var i = 1; i <= count; i++) {
      response.add({
          "id": "id_$i",
          "name": "Test Restaurant $i",
          "desc": "Test Description $i",
          "lat": 1.0,
          "lon": 1.0,
          "year": 2022,
          "address": "Test Address",
          "district": "Test District",
          "city": "Test City",
          "country": "Test Country",
          "tel": "1234567",
          "rating": 5.0,
          "logo": "Test Logo" });
    }
    return response;
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

  var locationHelper = MockLocationHelper();

  var cameraPosition = const CameraPosition(target: LatLng(0.0, 0.0), zoom: 14);
  var defaultCameraPosition =
      const CameraPosition(target: LatLng(39.925533, 32.866287), zoom: 4);
  var remoteRestaurants = _generateTestRestaurantList(10);

  blocTest("mapCubitGetPositionTest",
      build: () {
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.value(_createMockPosition()));
        final instance = FakeFirebaseFirestore();
        return MapCubit(locationHelper, instance.collection("restaurants").snapshots());
      },
      expect: () => [
            MapPositionLoadedState(cameraPosition),
          ],
      act: (MapCubit bloc) => bloc.getPosition());

  blocTest("mapCubitGetPositionFailTest",
      build: () {
        when(locationHelper.getUserLocation())
            .thenAnswer((_) => Future.error("Error"));
        final instance = FakeFirebaseFirestore();
        return MapCubit(locationHelper, instance.collection("restaurants").snapshots());
      },
      expect: () =>
          [MapPositionLoadedState(defaultCameraPosition), LocationErrorState()],
      act: (MapCubit bloc) => bloc.getPosition());

  blocTest("mapCubitGetRestaurantsTest",
      build: () {
        final instance = FakeFirebaseFirestore();
        _generateTestResponse(10).forEach((element) async {
          await instance.collection("restaurants").add(element);
        });
        return MapCubit(locationHelper, instance.collection("restaurants").snapshots());
      },
      expect: () => [MapRestaurantsLoadedState(remoteRestaurants)],
      act: (MapCubit bloc) => bloc.getRestaurants());

  blocTest("mapCubitGetRestaurantsEmptyTest",
      build: () {
        final instance = FakeFirebaseFirestore();
        return MapCubit(locationHelper, instance.collection("restaurants").snapshots());
      },
      expect: () => [RequestErrorState()],
      act: (MapCubit bloc) => bloc.getRestaurants());

  blocTest("mapCubitNavigateRestaurantsTest",
      build: () {
        final instance = FakeFirebaseFirestore();
        return MapCubit(locationHelper, instance.collection("restaurants").snapshots());
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
          ]);
}
