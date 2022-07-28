import 'package:get_it/get_it.dart';
import 'package:historical_restaurants/database/app_database.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async {
  await $initGetIt(getIt);
}

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @preResolve
  Future<ApplicationDatabase> get applicationDatabase =>
      ApplicationDatabase.create();
}
