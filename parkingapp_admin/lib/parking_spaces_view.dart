import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/blocs/parkingspaces_bloc.dart';
import 'package:shared/models/parking_space.dart';

class ParkingSpacesView extends StatelessWidget {
  const ParkingSpacesView({super.key});

  @override
  Widget build(BuildContext context) {

    context.read<ParkingSpacesBloc>().add(GetAllParkingSpaces());

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: _ParkingSpacesList(),
    );
  }
}


class _ParkingSpacesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ParkingSpacesState parkingSpacesState = context.watch<ParkingSpacesBloc>().state;
    switch(parkingSpacesState) {
      case ParkingSpacesSuccess(parkingSpacesList: List<ParkingSpace> list):
        return parkingSpacesList(context, list);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget parkingSpacesList(BuildContext context, items) {
    return Container(
      width: 1080,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Parkeringsplatser", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween
            ,
            children: [
              const Text("Här visas alla parkeringsplatser som finns i systemet."),
              _ParkingSpacesActionCreate()
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
            width: 1080,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey[50],
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 660, 
                        child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 240, 
                        child: Text("Kostnad/timme", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                      ),
                      SizedBox(
                        width: 140, 
                        child: Text("", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ]
                  ),
                ),
                const Divider(height: 1, color: Colors.black12),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white, //selectedItem == items[index] ? Colors.blueGrey[50] : Colors.white,
                      child: Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 660,
                            child: Text(items[index].address),
                          ),
                          SizedBox(
                            width: 240,
                            child: Text(items[index].pricePerHour.toString(), textAlign: TextAlign.end),
                          ),
                          SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var item = await showItemEditDialog(context, items[index]);
                                    if(item != null && context.mounted) {
                                      context.read<ParkingSpacesBloc>().add(UpdateParkingSpace(parkingSpace: item));
                                    }
                                  },
                                  child: const MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: EdgeInsets.only(top:2, right:8, bottom:2, left: 8),
                                      child: Icon(Icons.edit, size: 18),
                                    )
                                  )
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var item = await showItemDeleteDialog(context, items[index]);
                                    if(item != null && context.mounted) {
                                      context.read<ParkingSpacesBloc>().add(DeleteParkingSpace(parkingSpace: item));
                                    }
                                  },
                                  child: const MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: EdgeInsets.only(top:2, right:8, bottom:2, left: 8),
                                      child: Icon(Icons.delete, size: 18),
                                    )
                                  )
                                ),
                                /*
                                IconButton(
                                  iconSize: 15,
                                  onPressed: () async {
                                    var item = await showItemEditDialog(context, items[index]);
                                    if(item != null && context.mounted) {
                                      context.read<ParkingSpacesBloc>().add(UpdateParkingSpace(parkingSpace: item));
                                    }
                                  }, 
                                  icon: const Icon(Icons.edit)
                                ),
                                IconButton(
                                  iconSize: 15,
                                  onPressed: () async {
                                     var item = await showItemDeleteDialog(context, items[index]);
                                    if(item != null && context.mounted) {
                                      context.read<ParkingSpacesBloc>().add(DeleteParkingSpace(parkingSpace: item));
                                    }
                                  }, 
                                  icon: const Icon(Icons.delete)
                                )
                                */
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
      ),
    );
  }
}

class _ParkingSpacesActionCreate extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return FilledButton (
      onPressed: () async {
        var item = await showItemEditDialog(context, null);
        if(item != null && context.mounted) {
          context.read<ParkingSpacesBloc>().add(CreateParkingSpace(parkingSpace: item));
        }
      },
      child: const Text("Lägg till ny parkeringsplats")
    );
  }
}

Future<ParkingSpace?> showItemEditDialog (BuildContext context, ParkingSpace? item) {
  
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

Future<ParkingSpace?> showItemDeleteDialog(BuildContext context, ParkingSpace item) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop(item); // dismiss dialog
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
  return showDialog(
    context: context, 
    builder: (BuildContext builder) => AlertDialog (
      title:  const Text("Vill du ta bort parkeringsplatsen?"),
      content: const Text(""),
      actions: [
        cancelButton,
        okButton,
      ],
    )
  );
  

}