import 'package:equatable/equatable.dart';
import 'package:historical_restaurants/preference_wrapper.dart';

abstract class SettingsState extends Equatable {}

class SettingsLoadingState extends SettingsState {
  @override
  List<Object?> get props => [];
}

class SettingsLoadedState extends SettingsState {
  final Map<String, bool> cityFilters;

  final SortOptions sortOption;

  SettingsLoadedState(this.cityFilters, this.sortOption);

  @override
  List<Object?> get props => [cityFilters, sortOption];
}
