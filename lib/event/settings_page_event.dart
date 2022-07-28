import 'package:equatable/equatable.dart';
import 'package:historical_restaurants/preference_wrapper.dart';

abstract class SettingsPageEvent extends Equatable {}

class SettingsLoadingEvent extends SettingsPageEvent{
  @override
  List<Object?> get props => [];
}

class SortOptionSelectedEvent extends SettingsPageEvent {
  final SortOptions option;

  SortOptionSelectedEvent(this.option);

  @override
  List<Object?> get props => [option];
}

class CityFilterSelectedEvent extends SettingsPageEvent {
  final String city;

  CityFilterSelectedEvent(this.city);

  @override
  List<Object?> get props => [city];
}
