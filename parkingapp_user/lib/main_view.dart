import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/parkings_bloc.dart';
import 'package:parkingapp_user/blocs/parkingspaces_bloc.dart';
import 'package:parkingapp_user/blocs/persons_bloc.dart';
import 'package:parkingapp_user/blocs/vehicles_bloc.dart';
import 'package:parkingapp_user/account_view.dart';
import 'package:parkingapp_user/parkings_view.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:parkingapp_user/vehicles_view.dart';
import 'package:parkingapp_user/login_view.dart';

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
      case AuthError(error: String? errMsg):
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
  late PersonRepository repository;
  
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