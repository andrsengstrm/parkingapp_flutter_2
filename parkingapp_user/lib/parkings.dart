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

    context.read<ParkingsBloc>().add(ReadParkingsByUser(user:user));
    context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));
    context.read<ParkingSpacesBloc>().add(ReadAllParkingSpaces());

    return Container(
      //color: Colors.blue,
      child: Column(
        children: [
          _ParkingsStartParking(user),
          Expanded(
            child: _ParkingsList(user) 
          )
          //
        ]
      ),
    );
  }

}


//start a new parking
class _ParkingsStartParking extends StatelessWidget {
  final Person user;
  const _ParkingsStartParking(this.user);

  @override
  Widget build(BuildContext context) {

    late List<Vehicle> ownerVehiclesList;
    late List<ParkingSpace> parkingSpacesList;

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
            if(context.mounted) {
              context.read<ParkingsBloc>().add(CreateParking(parking: newParking));
            }
          }
        },
        child: const Text("Starta parkering")
      ),
    );
  }

}


//show a list of parkings
class _ParkingsList extends StatelessWidget {
  final Person user;
  const _ParkingsList(this.user);

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
    var activeParkings = list.where((p) => p.endTime == null).toList();
    var finishedParkings = list.where((p) => p.endTime != null).toList();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        //color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Aktiva parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
            activeParkings.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: activeParkings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("${activeParkings[index].vehicle!.regId} - ${activeParkings[index].parkingSpace!.address}"),
                      onTap: () async {
                          var updatedParking = await showEditParkingDialog(context, activeParkings[index]);
                          if(updatedParking != null) {
                            if(context.mounted) {
                              context.read<ParkingsBloc>().add(UpdateParking(parking: updatedParking));
                            }
                          }
                      } ,
                    ),
                  );
                },
              )
            : const Text("Det finns inga aktiva parkeringar"),
            const SizedBox(height: 16),
            const Text("Avslutade parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
            finishedParkings.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: finishedParkings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("${finishedParkings[index].vehicle!.regId} - ${finishedParkings[index].parkingSpace!.address}"),
                      onTap: () async {
                          var updatedParking = await showEditParkingDialog(context, finishedParkings[index]);
                          if(updatedParking != null) {
                            if(context.mounted) {
                              context.read<ParkingsBloc>().add(UpdateParking(parking: updatedParking));
                              context.read<ParkingsBloc>().add(ReadParkingsByUser(user:user));
                            }
                          }
                      } ,
                    ),
                  );
                },
              )
            : const Text("Det finns inga avslutade parkeringar"),
          ],
        ),
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

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
      child: Container(
        padding: const EdgeInsets.all(16),
        //color: Colors.green,
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
                decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                    debugPrint("Startar en parkering...");
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
      )
    )
  );
}


Future<Parking?>? showEditParkingDialog(BuildContext context, Parking selectedParking ) {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.green,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Parkering",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(width: double.infinity,height: 16),
              const Text("Parkeringens starttid"),
              Text(
                selectedParking.startTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              selectedParking.endTime == null
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      String endTime = Helpers().formatDate(DateTime.now());
                      selectedParking.endTime = endTime;
                      Navigator.of(context).pop(selectedParking);
                    }
                  }, 
                  child: const Text("Avsluta parkering")
                )
              : const SizedBox.shrink(),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Stäng"),
                onPressed: () { 
                  Navigator.of(context).pop(null);
                },
              )
            ],
          ),
        ),
      )
    )
  );
}