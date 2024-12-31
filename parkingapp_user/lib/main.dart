import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/parkings_bloc.dart';
import 'package:parkingapp_user/blocs/parkingspaces_bloc.dart';
import 'package:parkingapp_user/blocs/persons_bloc.dart';
import 'package:parkingapp_user/blocs/vehicles_bloc.dart';
import 'package:parkingapp_user/account_view.dart';
import 'package:parkingapp_user/parkings.dart';
import 'package:parkingapp_user/vehicles.dart';
import 'package:parkingapp_user/login.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MainView()
    );
  }
}

//handle auth
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {

    final authState = context.watch<AuthBloc>().state;
    switch(authState) {
      case AuthInitial():
        return const Login();
      case AuthInProgess():
       return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 1)));
      case AuthSuccess():
        return const MainNav();
      case AuthFailure(error: String errMsg):
       return Login(message: errMsg);
    }
  }

}


//main nav for app
class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {

  get destinations => const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.local_parking), label:"Parkeringar"),
    NavigationDestination(icon: Icon(Icons.fire_truck), label:"Fordon"),
    NavigationDestination(icon: Icon(Icons.person), label:"Konto")
  ];

  final views = [
    const ParkingsView(),
    const VehiclesView(),
    const AccountView()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ParkingsBloc()),
        BlocProvider(create: (context) => PersonsBloc()),
        BlocProvider(create: (context) => VehiclesBloc()),
        BlocProvider(create: (context) => ParkingSpacesBloc())
      ],
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.blue,
          title: const Text("Parkeringsappen")
        ),
        bottomNavigationBar: NavigationBar(
          destinations: destinations, 
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(0),
          //color: Colors.red,
          child: SafeArea(
            child: views[_selectedIndex]
          )
        ),
      )
    );
  }
}



