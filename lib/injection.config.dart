// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'bloc/map_cubit.dart' as _i6;
import 'injection.dart' as _i7;
import 'utils/LocationHelper.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  gh.factory<_i3.LocationHelper>(() => _i3.LocationHelper());
  gh.factory<_i4.Stream<_i5.QuerySnapshot<Map<String, dynamic>>>>(
      () => appModule.restaurantStream);
  gh.factory<_i6.MapCubit>(() => _i6.MapCubit(get<_i3.LocationHelper>(),
      get<_i4.Stream<_i5.QuerySnapshot<Map<String, dynamic>>>>()));
  return get;
}

class _$AppModule extends _i7.AppModule {}
