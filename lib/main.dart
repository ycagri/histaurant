import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  await configureDependencies();
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
      title: 'Histaurant',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: const MaterialColor(0xffe4005f, color),
      ),
      home: const MainPage(title: 'Histaurant'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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
          BlocProvider(create: (context) => getIt<MapCubit>()),
          BlocProvider(create: (context) => getIt<MapCubit>())
        ],
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                const MapPage(),
                ListPage(_onItemTapped)
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                )
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xffe4005f),
              onTap: _onItemTapped,
            )));
  }
}
