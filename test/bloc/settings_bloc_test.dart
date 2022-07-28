import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:historical_restaurants/bloc/settings_bloc.dart';
import 'package:historical_restaurants/event/settings_page_event.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/repository/settings_repository.dart';
import 'package:historical_restaurants/state/settings_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_bloc_test.mocks.dart';
//e4005f
@GenerateMocks([],
    customMocks: [MockSpec<SettingsRepository>(returnNullOnMissingStub: true)])
void main() {
  final cityFilters = <String, bool>{"city1": false, "city2": false};
  final repository = MockSettingsRepository();
  when(repository.getSortOption()).thenReturn(SortOptions.cityAscending);
  when(repository.getCityFilters())
      .thenAnswer((_) => Future.value(cityFilters));
  group("SettingsBlocTest", () {
    blocTest("settingsBlocInitTest",
        build: () => SettingsBloc(repository),
        act: (Bloc bloc) => bloc.add(SettingsLoadingEvent()),
        expect: () =>
            [SettingsLoadedState(cityFilters, SortOptions.cityAscending)]);

    blocTest("settingsBlocSelectSortOptionTest",
        build: () => SettingsBloc(repository),
        act: (Bloc bloc) =>
            bloc.add(SortOptionSelectedEvent(SortOptions.distanceAscending)),
        expect: () =>
            [SettingsLoadedState(cityFilters, SortOptions.distanceAscending)],
        verify: (_) =>
            verify(repository.setSortOption(SortOptions.distanceAscending))
                .called(1));

    blocTest("settingsBlocSelectFilterTest",
        build: () => SettingsBloc(repository),
        act: (Bloc bloc) => bloc.add(CityFilterSelectedEvent("city1")),
        expect: () =>
            [SettingsLoadedState(cityFilters, SortOptions.cityAscending)],
        verify: (_) =>
            verify(repository.addOrRemoveCityFilter("city1")).called(1));
  });
}
