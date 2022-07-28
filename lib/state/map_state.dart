import 'package:equatable/equatable.dart';

import '../database/restaurant.dart';

class MapState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapLoadingState extends MapState {}

class MapRestaurantsLoadedState extends MapState {
  final List<Restaurant> restaurants;

  MapRestaurantsLoadedState(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}
