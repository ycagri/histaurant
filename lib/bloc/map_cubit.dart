import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/repository/map_repository.dart';
import 'package:historical_restaurants/state/map_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final MapRepository _repository;

  late GoogleMapController _controller;

  MapCubit(this._repository) : super(MapLoadingState()) {
    _repository.registerSettingsChangeListener(getRestaurants);
  }

  void setMapController(GoogleMapController controller) {
    _controller = controller;
    _getUserLocation();
  }

  void getRestaurants() async {
    var restaurants = await _repository.getRestaurantsFromLocal();
    emit(MapRestaurantsLoadedState(restaurants));
  }

  void moveToRestaurant(Restaurant r) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(r.lat, r.lon), zoom: 16)));
  }

  void _getUserLocation() async {
    var pos = await _repository.getUserLocation();
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 12)));
  }

  @override
  Future<void> close() {
    _repository.unregisterSettingsChangeListener(getRestaurants);
    return super.close();
  }
}
