// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import 'api/rest_api.dart' as _i5;
import 'bloc/map_cubit.dart' as _i9;
import 'bloc/settings_bloc.dart' as _i10;
import 'database/app_database.dart' as _i3;
import 'injection.dart' as _i11;
import 'preference_wrapper.dart' as _i7;
import 'repository/settings_repository.dart' as _i8;
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
  gh.singleton<_i7.PreferenceWrapper>(
      _i7.PreferenceWrapper(get<_i6.SharedPreferences>()));
  gh.factory<_i8.SettingsRepository>(() => _i8.SettingsRepository(
      get<_i3.ApplicationDatabase>(), get<_i7.PreferenceWrapper>()));
  gh.factory<_i9.MapCubit>(() => _i9.MapCubit(
      get<_i3.ApplicationDatabase>(),
      get<_i7.PreferenceWrapper>(),
      get<_i4.LocationHelper>(),
      get<_i5.RestApi>()));
  gh.factory<_i10.SettingsBloc>(
      () => _i10.SettingsBloc(get<_i8.SettingsRepository>()));
  return get;
}

class _$AppModule extends _i11.AppModule {}
