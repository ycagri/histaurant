// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import 'api/rest_api.dart' as _i5;
import 'bloc/map_cubit.dart' as _i7;
import 'database/app_database.dart' as _i3;
import 'injection.dart' as _i9;
import 'preference_wrapper.dart' as _i8;
import 'utils/LocationHelper.dart'
    as _i4; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  await gh.factoryAsync<_i3.ApplicationDatabase>(
      () => appModule.applicationDatabase,
      preResolve: true);
  gh.factory<_i4.LocationHelper>(() => _i4.LocationHelper());
  gh.factory<_i5.RestApi>(() => _i5.RestApi());
  await gh.factoryAsync<_i6.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.factory<_i7.MapCubit>(() => _i7.MapCubit(get<_i3.ApplicationDatabase>(),
      get<_i4.LocationHelper>(), get<_i5.RestApi>()));
  gh.singleton<_i8.PreferenceWrapper>(
      _i8.PreferenceWrapper(get<_i6.SharedPreferences>()));
  return get;
}

class _$AppModule extends _i9.AppModule {}
