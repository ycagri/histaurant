import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/restaurant.dart';

class MapState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapLoadingState extends MapState {}

class MapPositionLoadedState extends MapState {
  final CameraPosition position;

  MapPositionLoadedState(this.position);

  @override
  List<Object> get props => [position];
}

class MapRestaurantsLoadedState extends MapState {

  final List<Restaurant> restaurants;

  MapRestaurantsLoadedState(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class MapNavigateRestaurantState extends MapState {
  final String id;

  final CameraPosition position;

  MapNavigateRestaurantState(this.id, this.position);

  @override
  List<Object> get props => [id, position];
}

class LocationErrorState extends MapState {
}

class RequestErrorState extends MapState {
}