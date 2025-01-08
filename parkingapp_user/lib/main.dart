import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/main_view.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(), 
      child: const ParkingApp()
    )
  );
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkeringsappen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.light,
        ),
        //
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor:Colors.amber,
          brightness: Brightness.dark
        ),
        //brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MainView()
    );
  }
}




