// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import 'bloc/list_cubit.dart' as _i11;
import 'bloc/map_cubit.dart' as _i12;
import 'bloc/settings_bloc.dart' as _i10;
import 'database/app_database.dart' as _i3;
import 'injection.dart' as _i13;
import 'preference_wrapper.dart' as _i6;
import 'repository/list_repository.dart' as _i8;
import 'repository/map_repository.dart' as _i9;
import 'repository/settings_repository.dart' as _i7;
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
  await gh.factoryAsync<_i5.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true);
  gh.singleton<_i6.PreferenceWrapper>(
      _i6.PreferenceWrapper(get<_i5.SharedPreferences>()));
  gh.factory<_i7.SettingsRepository>(() => _i7.SettingsRepository(
      get<_i3.ApplicationDatabase>(), get<_i6.PreferenceWrapper>()));
  gh.factory<_i8.ListRepository>(() => _i8.ListRepository(
      get<_i3.ApplicationDatabase>(), get<_i6.PreferenceWrapper>()));
  gh.factory<_i9.MapRepository>(() => _i9.MapRepository(
      get<_i3.ApplicationDatabase>(),
      get<_i6.PreferenceWrapper>(),
      get<_i4.LocationHelper>()));
  gh.factory<_i10.SettingsBloc>(
      () => _i10.SettingsBloc(get<_i7.SettingsRepository>()));
  gh.factory<_i11.ListCubit>(() => _i11.ListCubit(get<_i8.ListRepository>()));
  gh.factory<_i12.MapCubit>(() => _i12.MapCubit(get<_i9.MapRepository>()));
  return get;
}

class _$AppModule extends _i13.AppModule {}
