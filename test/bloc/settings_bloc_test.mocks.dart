// Mocks generated by Mockito 5.3.0 from annotations
// in historical_restaurants/test/bloc/settings_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:historical_restaurants/preference_wrapper.dart' as _i4;
import 'package:historical_restaurants/repository/settings_repository.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [SettingsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsRepository extends _i1.Mock
    implements _i2.SettingsRepository {
  @override
  _i3.Future<Map<String, bool>> getCityFilters() => (super.noSuchMethod(
          Invocation.method(#getCityFilters, []),
          returnValue: _i3.Future<Map<String, bool>>.value(<String, bool>{}))
      as _i3.Future<Map<String, bool>>);
  @override
  void addOrRemoveCityFilter(String? city) =>
      super.noSuchMethod(Invocation.method(#addOrRemoveCityFilter, [city]),
          returnValueForMissingStub: null);
  @override
  _i4.SortOptions getSortOption() => (super.noSuchMethod(
      Invocation.method(#getSortOption, []),
      returnValue: _i4.SortOptions.alphabeticallyAscending) as _i4.SortOptions);
  @override
  void setSortOption(_i4.SortOptions? option) =>
      super.noSuchMethod(Invocation.method(#setSortOption, [option]),
          returnValueForMissingStub: null);
}
