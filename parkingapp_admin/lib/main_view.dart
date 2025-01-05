import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/blocs/parkings_bloc.dart';
import 'package:parkingapp_admin/blocs/parkingspaces_bloc.dart';
import 'package:parkingapp_admin/dashboard_view.dart';
import 'package:parkingapp_admin/parking_spaces_view.dart';
import 'package:parkingapp_admin/parkings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  
  get destinations => const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Parkeringar')),
    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Parkeringsplatser'))
  ];

  int _selectedIndex = 0;

  var views = const [
    DashboardView(),
    ParkingsView(),
    ParkingSpacesView()
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ParkingsBloc()),
        BlocProvider(create: (context) => ParkingSpacesBloc())
      ],
      child: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: destinations, 
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: true,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: views[_selectedIndex]
            )
          ],
        )
      ),
    );
  }
}