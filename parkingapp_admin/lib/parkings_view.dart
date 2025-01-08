import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/blocs/parkings_bloc.dart';
import 'package:shared/models/parking.dart';

class ParkingsView extends StatelessWidget {
  
  const ParkingsView({super.key});

  @override
  Widget build(BuildContext context) {

    context.read<ParkingsBloc>().add(ReadAllParkings());

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              const Text("Parkeringar", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _ActiveParkingsList(),
              const SizedBox(height: 32),
              _FinishedParkingsList(),
              const SizedBox(height: 32),
            ],
          )
        ),
        const Positioned(
          bottom: 16,
          left: 16,
          child: SizedBox.shrink()
        )
      ]
    );
  }

}


class _ActiveParkingsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final parkingsState = context.watch<ParkingsBloc>().state;
    switch(parkingsState) {
      case ParkingsSuccess(parkingsList: var list):
        return parkingsList(context, list);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget parkingsList(BuildContext context, items) {
    items = items.where((p) => p.endTime == null).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Aktiva parkeringar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          width: 1080,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.all(8),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200, 
                      child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("Registreringsnummer", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("Starttid", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 140, 
                      child: Text("Nuvarande kostnad", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    )
                  ]
                ),
              ),
              const Divider(height: 1, color: Colors.black12),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Row (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(items[index].parkingSpace!.address),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(items[index].vehicle!.regId),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(items[index].startTime),
                        ),
                        const SizedBox(
                          width: 200,
                          child: Text(""),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text("${items[index].getCostForParking()}, kr", textAlign: TextAlign.end),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  showAlertDialog(context, items[index]);
                                },
                                child: const MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Padding(
                                    padding: EdgeInsets.only(top:2, right:8, bottom:2, left: 8),
                                    child: Icon(Icons.info, size: 18)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.black12),
              )
            ]
          ),
        ),
      ],
    );
  } 

}

class _FinishedParkingsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final parkingsState = context.watch<ParkingsBloc>().state;
    switch(parkingsState) {
      case ParkingsSuccess(parkingsList: var list):
        return parkingsList(context, list);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget parkingsList(BuildContext context, items) {
    items = items.where((p) => p.endTime != null).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Avslutade parkeringar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          width: 1080,
          decoration: BoxDecoration(
                border: Border.all(color: Colors.black12)
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[50],
                padding: const EdgeInsets.all(8),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200, 
                      child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("Registreringsnummer", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("Starttid", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 200, 
                      child: Text("Sluttid", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 140, 
                      child: Text("Total kostnad", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                    )
                  ]
                ),
              ),
              const Divider(height: 1, color: Colors.black12),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Row (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(items[index].parkingSpace!.address),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(items[index].vehicle!.regId),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(items[index].startTime),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(items[index].endTime),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text("${items[index].getCostForParking()} kr", textAlign: TextAlign.end),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  showAlertDialog(context, items[index]);
                                },
                                child: const MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Padding(
                                    padding: EdgeInsets.only(top:2, right:8, bottom:2, left: 8),
                                    child: Icon(Icons.info, size: 18)),
                                ),
                              ),
                            ],
                          ),
                        ) 
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(height: 1, color: Colors.black12),
              ),
            ]
          ),
        ),
      ],
    );
  } 
  
}

showAlertDialog(BuildContext context, Parking selectedParking) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

    // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title:  Text(selectedParking.vehicle!.regId),
    content: Wrap(
      direction: Axis.vertical,
      spacing: 4,
      children: [
        Text("Fordonstyp: ${selectedParking.vehicle!.vehicleType}"),
        Text("Fordonets ägare: ${selectedParking.vehicle!.owner!.name}"),
        Text("Parkeringens aktuella saldo: ${selectedParking.getCostForParking()} kr"),
      ],
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}


/*

child: Row (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child:  Text(snapshot.data![index].id.toString()),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(snapshot.data![index].vehicle!.regId),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(snapshot.data![index].parkingSpace!.address),
                              ),
                            ],
                          )

return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(snapshot.data![index].id.toString());
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                );

*/