import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:injectable/injectable.dart';

import '../utils/LocationHelper.dart';

@injectable
@singleton
class MapCubit extends Cubit<MapState> {
  final LocationHelper _locationHelper;

  final Stream<QuerySnapshot<Map<String, dynamic>>> _restaurantStream;

  MapCubit(this._locationHelper, this._restaurantStream) : super(MapLoadingState());

  void navigateToRestaurant(Restaurant restaurant) {
    emit(MapNavigateRestaurantState(
        restaurant.id,
        CameraPosition(
            target: LatLng(restaurant.lat, restaurant.lon), zoom: 10)));
  }

  void getRestaurants() {
    _restaurantStream.map((event) {
      List<Restaurant> restaurants = <Restaurant>[];
      for (var element in event.docs) {
        var restaurant = Restaurant.fromJson(element.data());
        restaurants.add(restaurant);
      }
      return restaurants;
    }).listen((event) {
      if (event.isEmpty) {
        emit(RequestErrorState());
      } else {
        emit(MapRestaurantsLoadedState(event));
      }
    });
  }

  void getPosition() async {
    _locationHelper.getUserLocation().then((value) {
      emit(MapPositionLoadedState(_createCameraPosition(value)));
    }).onError((error, stackTrace) {
      emit(MapPositionLoadedState(_createCameraPosition(null)));
      emit(LocationErrorState());
    });
  }

  CameraPosition _createCameraPosition(Position? currentPosition) {
    bool isDefaultLocation = _shouldUseDefaultPosition(currentPosition);
    var lat = isDefaultLocation ? 39.925533 : currentPosition!.latitude;
    var lon = isDefaultLocation ? 32.866287 : currentPosition!.longitude;
    var zoom = isDefaultLocation ? 4.0 : 14.0;
    return CameraPosition(target: LatLng(lat, lon), zoom: zoom);
  }

  bool _shouldUseDefaultPosition(Position? position){
    return position == null || position.longitude < 20 || position.longitude > 50
        || position.latitude < 35 || position.longitude > 45;
  }
}
