import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/injection.dart';
import 'package:historical_restaurants/list_page.dart';

import 'firebase_options.dart';
import 'map_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const Map<int, Color> color = {
    50: Color.fromRGBO(228, 0, 95, .1),
    100: Color.fromRGBO(228, 0, 95, .2),
    200: Color.fromRGBO(228, 0, 95, .3),
    300: Color.fromRGBO(228, 0, 95, .4),
    400: Color.fromRGBO(228, 0, 95, .5),
    500: Color.fromRGBO(228, 0, 95, .6),
    600: Color.fromRGBO(228, 0, 95, .7),
    700: Color.fromRGBO(228, 0, 95, .8),
    800: Color.fromRGBO(228, 0, 95, .9),
    900: Color.fromRGBO(228, 0, 95, 1),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (c) => AppLocalizations.of(c)!.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xffe4005f, color),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<MapCubit>())
        ],
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.appName),
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[const MapPage(), ListPage(_onItemTapped)],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.map),
                  label: AppLocalizations.of(context)!.map,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.list),
                  label: AppLocalizations.of(context)!.list,
                )
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xffe4005f),
              onTap: _onItemTapped,
            )));
  }
}
