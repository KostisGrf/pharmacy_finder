import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:pharmacy_finder/screens/home_screen.dart';
import 'package:pharmacy_finder/screens/results_screen.dart';
import 'package:provider/provider.dart';
import 'package:pharmacy_finder/blocs/application_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApplicationBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pharmacy Finder',
          initialRoute: '/',
          routes:{
            '/':(context)=>const HomeScreen(),
            '/results_screen':(context)=>const ResultsScreen()
          }
        ));
  }
}
