import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/parkings_bloc.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/person.dart';

class ParkingsList extends StatelessWidget {
  const ParkingsList({super.key});

  //final Person user;

  @override
  Widget build(BuildContext context) {

    //final parkingsBloc = BlocProvider.of(context) .ParkingsBloc();
    //var parkingsList = List<Parking>.empty(growable: true);
    //context.read<ParkingsBloc>().add(GetParkingsByUser(user:user));
    var state = context.watch<ParkingsBloc>().state;

    switch(state) {
      case ParkingsSuccess(parkingsList: var list): 
        return parkingsList(context, list);
      default: 
        return const SizedBox.shrink();
    }

    return const SizedBox.shrink();

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


/*
setState((){
  selectedParking = activeParkings[index];
});
var parkingToBeFinished = await showSelectedParkingDialog(context, selectedParking);
if(parkingToBeFinished == null) {
  return;
}
var endedParking = await endParking(parkingToBeFinished);
if(endedParking != null) {
  setState(() {
    parkingsList = getParkingsList(user.email);
  });
}
*/



    /*
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          const Text("Aktiva parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
          BlocBuilder<ParkingsBloc, ParkingsState>(
            builder: (context, state) {
              switch(state) {
                case ParkingsInitial():
                  // TODO: Handle this case.
                case ParkingsLoading():
                  // TODO: Handle this case.
                case ParkingsSuccess(parkingsList:):
                  var parkingsList = ;
                case ParkingsError():

                default:
                  return const SizedBox.shrink();
                  // TODO: Handle this case.
              }
            }
          )
          /*
          ListView.builder(
            itemCount: parkingsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(parkingsList[index].vehicleDb)
              );
            },
          ),
          */
          /*
          FutureBuilder<List<Parking>?>(
            future: parkingsList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                var items = snapshot.data;
                var activeParkings = items!.where((p) => p.endTime == null).toList();
                if(activeParkings.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: activeParkings.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              /*
                              setState((){
                                selectedParking = activeParkings[index];
                              });
                              var parkingToBeFinished = await showSelectedParkingDialog(context, selectedParking);
                              if(parkingToBeFinished == null) {
                                return;
                              }
                              var endedParking = await endParking(parkingToBeFinished);
                              if(endedParking != null) {
                                setState(() {
                                  parkingsList = getParkingsList(user.email);
                                });
                              }
                              */
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Card(
                                child: ListTile(
                                  title: Text("${activeParkings[index].vehicle!.regId} - ${activeParkings[index].parkingSpace!.address}"),
                                )
                              )
                            )
                          );
                        },
                      )
                    ]
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text("Det finns inga aktiva parkeringar"),
                  );
                }
              } else if(snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text("Det gick inte att hämta data!"),
                );
              } 
              return const Padding(
                padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                child: LinearProgressIndicator(
                  minHeight: 1,
                )
              );
            }
          ),
          */
            
            
          SizedBox(height: 32),
          Text("Tidigare parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
            
          /*
          FutureBuilder<List<Parking>?>(
            future: parkingsList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                var items = snapshot.data;
                var inactiveParkings = items!.where((p) => p.endTime != null).toList();
                if(inactiveParkings.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: inactiveParkings.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              setState((){
                                selectedParking = inactiveParkings[index];
                              });
                              await showSelectedParkingDialog(context, selectedParking); 
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Card(
                                child: ListTile(
                                  title: Text("${inactiveParkings[index].vehicle!.regId} - ${inactiveParkings[index].parkingSpace!.address}"),
                                )
                              )
                            )
                          );
                        },
                      )
                    ]
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text("Det finns inga tidigare parkeringar"),
                  );
                }
              } else if(snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text("Det gick inte att hämta data!"),
                );
              } 
              return const Padding(
                padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                child: LinearProgressIndicator(
                  minHeight: 1,
                )
              );
            }
          )
          */
        ],
      ),
    );
    */
  
}