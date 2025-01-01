import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/blocs/parkingspaces_bloc.dart';
import 'package:shared/models/parking_space.dart';

class ParkingSpacesView extends StatelessWidget {
  const ParkingSpacesView({super.key});

  @override
  Widget build(BuildContext context) {

    context.read<ParkingSpacesBloc>().add(GetAllParkingSpaces());

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: _ParkingSpacesList(),
        ),
        Positioned(
            bottom: 16,
            left: 16,
            child: 
              Row (
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right:8.0),
                      child: _ParkingSpacesCreate()
                    )
                ]
              ) 
          )
      ]
    );
  }
}


class _ParkingSpacesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ParkingSpacesState parkingSpacesState = context.watch<ParkingSpacesBloc>().state;
    switch(parkingSpacesState) {
      case GetAllParkingSpacesSuccess(parkingSpacesList: List<ParkingSpace> list):
        return parkingSpacesList(context, list);
      case CreateParkingSpaceSuccess():
        context.read<ParkingSpacesBloc>().add(GetAllParkingSpaces());
        return const SizedBox.shrink();
      case UpdateParkingSpaceSuccess():
        context.read<ParkingSpacesBloc>().add(GetAllParkingSpaces());
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget parkingSpacesList(BuildContext context, items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Parkeringsplatser", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200, 
              child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: 200, 
              child: Text("Kostnad/timme", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ]
        ),
        const SizedBox(height: 8),
        ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                var item = await showItemForm(context, items[index]);
                if(item != null && context.mounted) {
                  context.read<ParkingSpacesBloc>().add(UpdateParkingSpace(parkingSpace: item));
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.white, //selectedItem == items[index] ? Colors.blueGrey[50] : Colors.white,
                  child: Row (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(items[index].address),
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(items[index].pricePerHour.toString()),
                      )
                    ],
                  ),
                ),
              )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox.shrink(),
        )
      ]
    );
  }
}

class _ParkingSpacesCreate extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton (
      onPressed: () async {
        var item = await showItemForm(context, null);
        if(item != null && context.mounted) {
          context.read<ParkingSpacesBloc>().add(CreateParkingSpace(parkingSpace: item));
        }
      },
      child: const Text("Lägg till ny parkeringsplats")
    );
  }
}

Future<ParkingSpace?> showItemForm (BuildContext context, ParkingSpace? item) {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? address;
  double pricePerHour = 0;
  
  return showDialog<ParkingSpace?>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
        title:  item != null ? const Text("Uppdatera parkeringsplats") : const Text("Lägg till en ny parkeringsplats"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: item?.address,
                decoration: const InputDecoration(
                  hintText: "Address",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i en adress";
                  }
                  return null;
                },
                onSaved: (value) => address = value,
              ),
              TextFormField(
                initialValue: item?.pricePerHour.toString(),
                decoration: const InputDecoration(
                  hintText: "Kostnad per timme",
                ),
                validator: (String? value) {
                  var pricePerHour = double.tryParse(value!);
                  if(pricePerHour == null) {
                    return "Du måste fylla i ett pris per timme";
                  }
                  return null;
                },
                onSaved: (value) {
                  if(value != null && double.tryParse(value) != null) {
                    pricePerHour = double.parse(value);
                  } 
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top:32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8, right:8),
                      child: TextButton(
                        onPressed: () {
                          if(context.mounted) {
                            Navigator.of(context).pop(null);
                          }             
                        },
                        child: const Text("Avbryt"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8),
                      child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            item = ParkingSpace(id: item?.id, address: address!, pricePerHour: pricePerHour);
                            if(context.mounted) {
                              Navigator.of(context).pop(item);
                            }                 
                          } 
                        },
                        child: const Text("OK"),
                      ),
                    ),
                  ]
                ),
              )
            ],
          )
        ),
    )
  );

}

Future<String?> showRemovalDialog(BuildContext context, ParkingSpace item) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop("confirm"); // dismiss dialog
    },
  );

  // set up the button
  Widget cancelButton = TextButton(
    child: const Text("Avbryt"),
    onPressed: () { 
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

    // set up the AlertDialog
  return showDialog<String>(
    context: context, 
    builder: (BuildContext builder) {
      return AlertDialog (
        title:  const Text("Vill du ta bort parkeringsplatsen?"),
        content: const Text(""),
        actions: [
          cancelButton,
          okButton,
        ],
      );
    }
  );
  

}