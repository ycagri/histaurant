import 'package:equatable/equatable.dart';

import '../database/restaurant.dart';

abstract class ListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListLoadingState extends ListState {}

class ListLoadedState extends ListState {
  final List<Restaurant> restaurants;

  ListLoadedState(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}
