import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:historical_restaurants/bloc/list_cubit.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/repository/list_repository.dart';
import 'package:historical_restaurants/state/list_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_cubit_test.mocks.dart';

@GenerateMocks([],
    customMocks: [MockSpec<ListRepository>(returnNullOnMissingStub: true)])
void main() {
  List<Restaurant> _generateTestRestaurantList(int count) {
    List<Restaurant> restaurants = <Restaurant>[];
    for (var i = 1; i <= count; i++) {
      restaurants.add(Restaurant(
          id: "id_$i",
          name: "Test Restaurant $i",
          desc: "Test Description $i",
          lat: 1.0,
          lon: 1.0,
          year: 2022,
          address: "Test Address",
          district: "Test District",
          city: "Test City",
          country: "Test Country",
          tel: "1234567",
          rating: 5.0,
          logo: "Test Logo",
          distance: 0.0));
    }
    return restaurants;
  }

  final repository = MockListRepository();
  var restaurants = _generateTestRestaurantList(10);
  var changedRestaurants = _generateTestRestaurantList(5);

  blocTest("listCubitTest",
      build: () {
        when(repository.getRestaurants())
            .thenAnswer((_) => Future.value(restaurants));
        final cubit = ListCubit(repository);
        var onChanged =
            verify(repository.registerSettingsChangeListener(captureAny));
        when(repository.getRestaurants())
            .thenAnswer((_) => Future.value(changedRestaurants));
        onChanged.captured[0].call();
        return cubit;
      },
      expect: () =>
          [ListLoadedState(restaurants), ListLoadedState(changedRestaurants)],
      tearDown: () => verify(
          repository.unregisterSettingsChangeListener(argThat(isNotNull))));
}
