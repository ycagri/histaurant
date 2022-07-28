import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:historical_restaurants/event/settings_page_event.dart';
import 'package:historical_restaurants/repository/settings_repository.dart';
import 'package:historical_restaurants/state/settings_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsBloc extends Bloc<SettingsPageEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(SettingsLoadingState()) {
    on<SettingsLoadingEvent>((event, emit) async {
      var option = _repository.getSortOption();
      emit(SettingsLoadedState(await _repository.getCityFilters(), option));
    });

    on<SortOptionSelectedEvent>((event, emit) async {
      var option = event.option;
      _repository.setSortOption(option);
      emit(SettingsLoadedState(await _repository.getCityFilters(), option));
    });

    on<CityFilterSelectedEvent>((event, emit) async {
      _repository.addOrRemoveCityFilter(event.city);
      var option = _repository.getSortOption();
      emit(SettingsLoadedState(await _repository.getCityFilters(), option));
    });
  }
}
