import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:injectable/injectable.dart';

import '../api/rest_api.dart';
import '../database/app_database.dart';
import '../preference_wrapper.dart';
import '../utils/LocationHelper.dart';

@injectable
@singleton
class MapCubit extends Cubit<MapState> {
  final ApplicationDatabase _database;

  final PreferenceWrapper _wrapper;

  final LocationHelper _locationHelper;

  final RestApi _restApi;

  Position? _currentPosition;

  MapCubit(this._database, this._wrapper, this._locationHelper, this._restApi)
      : super(MapLoadingState()) {
    _getPosition();
  }

  void _getPosition() async {
    _locationHelper.getUserLocation().then((value) {
      _currentPosition = value;
      emit(MapPositionLoadedState(_createCameraPosition()));
      _getRestaurants();
    }).onError((error, stackTrace) {
      _currentPosition = null;
      emit(MapPositionLoadedState(_createCameraPosition()));
      _getRestaurants();
    });
  }

  CameraPosition _createCameraPosition() {
    var lat = _currentPosition == null ? 39.925533 : _currentPosition!.latitude;
    var lon =
        _currentPosition == null ? 32.866287 : _currentPosition!.longitude;
    var zoom = _currentPosition == null ? 4.0 : 14.0;
    return CameraPosition(target: LatLng(lat, lon), zoom: zoom);
  }

  void _getRestaurants() {
    _database
        .getRestaurants(_wrapper.getCityFilters(), _wrapper.getSortSelection())
        .then((value) {
      emit(MapRestaurantsLoadedState(_createCameraPosition(), value));
      _getRestaurantsFromRemote();
    }).onError((error, stackTrace) {
      _getRestaurantsFromRemote();
    });
  }

  void _getRestaurantsFromRemote() {
    _restApi.getRestaurants().then((value) {
      _saveRestaurants(value);
      emit(MapRestaurantsLoadedState(_createCameraPosition(), value));
    }).onError((error, stackTrace) {});
  }

  void _saveRestaurants(List<Restaurant> restaurants) {
    _database.insertRestaurants(restaurants);
  }
}
