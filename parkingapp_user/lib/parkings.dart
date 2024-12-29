import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/parkings_bloc.dart';
import 'package:parkingapp_user/blocs/parkingspaces_bloc.dart';
import 'package:parkingapp_user/blocs/vehicles_bloc.dart';
import 'package:parkingapp_user/login.dart';
import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

class ParkingsView extends StatelessWidget {
  
  const ParkingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthBloc>().state;
    switch(authState) {
      case AuthSuccess(user: Person user):
        return parkingsMainView(context, user);
      default: 
        return const Login();
    }
  }

  Widget parkingsMainView(BuildContext context, Person user) {
    context.read<ParkingsBloc>().add(GetParkingsByUser(user:user));
    context.read<VehiclesBloc>().add(GetVehiclesByOwner(owner:user));
    context.read<ParkingSpacesBloc>().add(GetAllParkingSpaces());
    return Container(
      color: Colors.blue,
      child: const Column(
        children: [
          ParkingsStartParking(),
          Expanded(
            child: ParkingsList() 
          )
          //
        ]
      ),
    );
  }

}


//start a new parking
class ParkingsStartParking extends StatelessWidget {
  const ParkingsStartParking({super.key});

  @override
  Widget build(BuildContext context) {

    late Person owner;
    late List<Vehicle> ownerVehiclesList;
    late List<ParkingSpace> parkingSpacesList;

    final AuthState authState = context.watch<AuthBloc>().state;
    switch(authState) {
      case AuthSuccess(user: Person user):
        owner = user;
      default: 
        return const Login();
    }

    final VehiclesState vehiclesState = context.watch<VehiclesBloc>().state;
    switch(vehiclesState) {
      case VehiclesSuccess(vehiclesList: List<Vehicle> list):
        ownerVehiclesList = list;
      default:
        //
    }

    final ParkingSpacesState parkingSpacesState = context.watch<ParkingSpacesBloc>().state;
    switch(parkingSpacesState) {
      case ParkingSpacesSuccess(parkingSpacesList: List<ParkingSpace> list):
        parkingSpacesList = list;
      default:
        //
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(240, 240),
        ),
        onPressed: () async {
          var newParking = await showStartParkingDialog(context, ownerVehiclesList, parkingSpacesList);
          if(newParking != null) {
            debugPrint("Start a new parking...");
            if(context.mounted) {
              context.read<ParkingsBloc>().add(StartParking(newParking));
              context.read<ParkingsBloc>().add(GetParkingsByUser(user:owner));
            }
          }
        },
        child: const Text("Starta parkering")
      ),
    );
  }

}



//show a list of parkings
class ParkingsList extends StatelessWidget {
  const ParkingsList({super.key});

  @override
  Widget build(BuildContext context) {

    var state = context.watch<ParkingsBloc>().state;

    switch(state) {
      case ParkingsSuccess(parkingsList: var list): 
        return parkingsList(context, list);
      default: 
        return const SizedBox.shrink();
    }

  }

  Widget parkingsList(BuildContext context, list) {
    return Container(
      color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("${list[index].vehicle!.regId} - ${list[index].parkingSpace!.address}"),
                );
              },
            ),
          ),
        ]
      ),
    );
  }
}


Future<Parking?>? showStartParkingDialog(BuildContext context, List<Vehicle>? ownerVehiclesList, List<ParkingSpace>? parkingSpacesList ) {

  Vehicle? selectedVehicle;
  ParkingSpace? selectedParkingSpace;
  late Parking? newParking;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  /*
  Future<List<ParkingSpace>?> getAvailableParkingSpaces() async {
    var activeParkings = await ParkingRepository().getAll();
    var busyParkings = [];
    for(var i = 0; i < activeParkings!.length; i++) {
      var p = activeParkings[i];
      if(p.endTime == null) {
        if(!busyParkings.contains(p.parkingSpace!.id)) {
          busyParkings.add(p.parkingSpace!.id);
        }
      }
    }

    late List<ParkingSpace>? availableParkingSpaces = [];
    for(var i = 0; i < parkingSpaceList!.length; i++) {
      var p = parkingSpaceList[i];
      if(!busyParkings.contains(p.id)) {
        availableParkingSpaces.add(p);
      }
    }
    return availableParkingSpaces;
  }
  */
  //List<ParkingSpace> selectableParkingSpaceList = getAvailableParkingSpaces();

  return showDialog(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
    child: Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              "Starta parkering",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Vehicle>(
              decoration: const InputDecoration(filled: true, fillColor: Colors.white),
              //inputDecorationTheme: const InputDecorationTheme(filled: true, fillColor: Colors.white),
              value: selectedVehicle,
              hint: const Text("Välj fordon"),
              onChanged: (Vehicle? value) {
                selectedVehicle = value!;
              },
              items: ownerVehiclesList!.map<DropdownMenuItem<Vehicle>>((Vehicle v) {
                return DropdownMenuItem<Vehicle>(
                  value: v,
                  child: Text(v.regId),
                );
              }).toList(),
              validator: (Vehicle? vehicle) {
                if(vehicle != null) {
                    return null;
                } else {
                  return "Du måste välja ett fordon";
                }
                
              }
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ParkingSpace>(
              decoration: const InputDecoration(filled: true, fillColor: Colors.white),
              value: selectedParkingSpace,
              hint:const  Text("Välj parkeringsplats"),
              onChanged: (ParkingSpace? value) {
                selectedParkingSpace = value!;
              },
              items: parkingSpacesList!.map<DropdownMenuItem<ParkingSpace>>((ParkingSpace v) {
                return DropdownMenuItem<ParkingSpace>(
                  value: v,
                  child: Text(v.address),
                );
              }).toList(),  
              validator: (ParkingSpace? parkingSpace) {
                if(parkingSpace != null) {
                    return null;
                } else {
                  return "Du måste välja en parkeringsplats";
                }
                
              }  
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  String startTime = Helpers().formatDate(DateTime.now());
                  newParking = Parking(vehicle: selectedVehicle, parkingSpace: selectedParkingSpace, startTime: startTime);
                  Navigator.of(context).pop(newParking);
                }
              }, 
              child: const Text("Starta parkering")
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(300, 50),
              ),
              child: const Text("Avbryt"),
              onPressed: () { 
                Navigator.of(context).pop(null);
              },
            )
          ],
        ),
      ),
    ),
  )
  );
}


/*
Future<Parking?>? showStartParkingDialog(BuildContext context, Future<List<Vehicle>?> vehicleList, Future<List<ParkingSpace>?> parkingSpaceList ) {

  late Vehicle selectedVehicle;
  late ParkingSpace selectedParkingSpace;
  late Parking? newParking;
  final Size size = MediaQuery.sizeOf(context);
  final double contentWidth = size.width - 32;

  Future<List<ParkingSpace>?> getAvailableParkingSpaces() async {
    var activeParkings = await ParkingRepository().getAll();
    var busyParkings = [];
    for(var i = 0; i < activeParkings!.length; i++) {
      var p = activeParkings[i];
      if(p.endTime == null) {
        if(!busyParkings.contains(p.parkingSpace!.id)) {
          busyParkings.add(p.parkingSpace!.id);
        }
      }
    }
    var allParkingSpaces = await ParkingSpaceRepository().getAll();
    late List<ParkingSpace>? availableParkingSpaces = [];
    for(var i = 0; i < allParkingSpaces!.length; i++) {
      var p = allParkingSpaces[i];
      if(!busyParkings.contains(p.id)) {
        availableParkingSpaces.add(p);
      }
    }
    return availableParkingSpaces;
  }

  Future<List<ParkingSpace>?> selectableParkingSpaceList = getAvailableParkingSpaces();

  return showDialog(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
    child: Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Wrap(
          spacing: 16,
          direction: Axis.vertical,
          children: [
            const Text(
              "Starta parkering",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            FutureBuilder<List<Vehicle>?>(
              future: vehicleList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var items = snapshot.data;
                  if(items!.isNotEmpty) {
                    return DropdownMenu<Vehicle>(
                      width: contentWidth,
                      hintText: "Välj fordon",
                      onSelected: (Vehicle? value) {
                        selectedVehicle = value!;
                      },
                      dropdownMenuEntries: items.map<DropdownMenuEntry<Vehicle>>((Vehicle v) {
                        return DropdownMenuEntry<Vehicle>(
                          value: v,
                          label: v.regId,
                        );
                      }).toList(),    
                    );
                  }
                }
                return const Text("Det gick inte att visa fordon");
              }
            ),
            FutureBuilder<List<ParkingSpace>?>(
              future: selectableParkingSpaceList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var items = snapshot.data;
                  if(items!.isNotEmpty) {
                    return DropdownMenu<ParkingSpace>(
                      width: contentWidth,
                      hintText: "Välj parkeringsplats",
                      onSelected: (ParkingSpace? value) {
                        selectedParkingSpace = value!;
                      },
                      dropdownMenuEntries: items.map<DropdownMenuEntry<ParkingSpace>>((ParkingSpace v) {
                        return DropdownMenuEntry<ParkingSpace>(
                          value: v,
                          label: v.address,
                        );
                      }).toList(),    
                    );
                  }
                }
                return const Text("Det gick inte att visa parkeringar");
              }
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Starta parkering"),
              onPressed: () { 
                String startTime = Helpers().formatDate(DateTime.now());
                newParking = Parking(vehicle: selectedVehicle, parkingSpace: selectedParkingSpace, startTime: startTime);
                Navigator.of(context).pop(newParking);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Avbryt"),
              onPressed: () { 
                Navigator.of(context).pop(null);
              },
            )
          ]
        ),
      )
    )
  );
}
*/

/*
Future<Parking?> showSelectedParkingDialog(BuildContext context, Parking? selectedParking) {

  final Size size = MediaQuery.sizeOf(context);
  final double contentWidth = size.width - 32;

  return showDialog<Parking?>(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen( 
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Parkering", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Parkeringens starttid"),
            Text(
              selectedParking!.startTime,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 8),  
            selectedParking.endTime != null 
            ? Wrap(
                direction: Axis.vertical,
                children: [
                  const Text("Parkeringen sluttid"),
                  Text(selectedParking.endTime!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 8),
                ]
              )
            : const SizedBox.shrink(),
            const Text("Kostnad för parkeringen"),
            Text("${selectedParking.getCostForParking()} kr",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 8),
            selectedParking.endTime == null
            ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Avsluta parkering"),
              onPressed: () { 
                String endTime = Helpers().formatDate(DateTime.now());
                selectedParking.endTime = endTime;
                Navigator.of(context).pop(selectedParking);
              },
            )
            : const SizedBox.shrink(),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Stäng"),
              onPressed: () { 
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      )
    )
  );
}
*/
