import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/blocs/auth_bloc.dart';
import 'package:parkingapp_user/blocs/vehicles_bloc.dart';
import 'package:parkingapp_user/login_view.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

class VehiclesView extends StatelessWidget {
  const VehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthBloc>().state;
    switch(authState) {
      case AuthSuccess(user: Person user):
        return vehiclesMainView(context, user);
      default: 
        return const Login();
    }
  }

  Widget vehiclesMainView(BuildContext context, Person user) {

    context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));

    return Container(
      padding: const EdgeInsets.all(16),
      //color: Colors.amber,
      child: Column(
        children: [
          _VehiclesList(user)
        ],
      ) 
    );

  }
}


class _VehiclesList extends StatelessWidget {
  final Person user;
  const _VehiclesList(this.user);

  @override
  Widget build(BuildContext context) {

    var state = context.watch<VehiclesBloc>().state;
    switch(state) {
      case VehiclesLoading():
        return const CircularProgressIndicator(strokeWidth: 1);
      case VehiclesSuccess(vehiclesList: var list): 
        return vehiclesList(context, list);
      default: 
        return const SizedBox.shrink();
    }
  }

  Widget vehiclesList(BuildContext context, list) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        //color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mina Fordon", style: TextStyle(fontWeight: FontWeight.bold)),
            list != null && list.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text("${list[index].regId}"),
                      //onTap: () {
                        //var updatedVehicle = await showVehicleDetailsDialog(context, list[index], user);
                        //if(updatedVehicle != null) {
                        //  if(context.mounted) {
                        //    context.read<VehiclesBloc>().add(UpdateVehicle(vehicle: updatedVehicle));
                        //    context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));
                        //  }
                        //}
                      //},
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              var updatedVehicle = await showVehicleDetailsDialog(context, list[index], user);
                              if(updatedVehicle != null) {
                                if(context.mounted) {
                                  context.read<VehiclesBloc>().add(UpdateVehicle(vehicle: updatedVehicle));
                                  context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));
                                }
                              }
                            },
                            icon: const Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              var deleteVehicle = await showRemovalDialog(context, list[index]);
                              if(deleteVehicle != null) {
                                if(context.mounted) {
                                  context.read<VehiclesBloc>().add(DeleteVehicle(vehicle: deleteVehicle));
                                  context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));
                                }
                              }
                            },
                            icon: const Icon(Icons.delete)
                          ),
                        ],
                      )
                    ),
                  );
                },
              )
            : const Text("Det finns inga fordon"),
            const SizedBox(width: double.infinity,height: 16),
            GestureDetector(
              child: const Text("+ Lägg till fordon"),
              onTap: () async {
                var newVehicle = await showVehicleDetailsDialog(context, null, user);
                if(newVehicle != null) {
                  if(context.mounted) {
                    context.read<VehiclesBloc>().add(CreateVehicle(vehicle: newVehicle));
                    context.read<VehiclesBloc>().add(ReadVehiclesByOwnerEmail(user:user));
                  }
                }
              } ,
            )
          ],
        ),
      ),
    );
  }

}


Future<Vehicle?>? showVehicleDetailsDialog(BuildContext context, Vehicle? selectedVehicle, Person user ) {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? regId;
  String? vehicleType = selectedVehicle != null ? selectedVehicle.vehicleType: "";
  //var isUpdate = selectedVehicle != null ? true: false;
  var vehicleTypes = ["Bil", "MC", "Lastbil", "Ospecificerad"];

  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
      child: Container(
        padding: const EdgeInsets.all(16),
        //color: Colors.green,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fordon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(width: double.infinity,height: 16),
              TextFormField(
                initialValue: selectedVehicle?.regId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Registreringsnummer",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i ett registreringsnummer";
                  }
                  return null;
                },
                onSaved: (value) => regId = value,
              ),
              const SizedBox(width: double.infinity,height: 16),
              DropdownMenu<String>(
                width: double.infinity,
                initialSelection: selectedVehicle?.vehicleType,
                hintText: "Välj typ av fordon",
                onSelected: (String? value) {
                  vehicleType = value!;
                },
                dropdownMenuEntries: vehicleTypes.map<DropdownMenuEntry<String>>((String v) {
                  return DropdownMenuEntry<String>(
                    value: v,
                    label: v,
                  );
                }).toList(),    
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    debugPrint(regId);
                    debugPrint(vehicleType);
                    if(regId != null && vehicleType != null) {
                      selectedVehicle = Vehicle(id: selectedVehicle?.id, regId: regId!, vehicleType: vehicleType!, owner: user);
                      if(context.mounted) {
                        Navigator.of(context).pop(selectedVehicle);
                      }      
                    }        
                  } 
                },
                child: const Text("Spara"),
              ),
              const SizedBox(height: 16),
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


Future<Vehicle?>? showRemovalDialog(BuildContext context, Vehicle selectedVehicle) {

  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      var deleteVehicle = Vehicle(id: selectedVehicle.id, regId: selectedVehicle.regId, vehicleType: selectedVehicle.vehicleType, owner: selectedVehicle.owner, isDeleted: true);
      if(context.mounted) {
        Navigator.of(context).pop(deleteVehicle);
      }   
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("Avbryt"),
    onPressed: () { 
      Navigator.of(context).pop(null);
    },
  );

  return showDialog(
    context: context, 
    builder: (BuildContext builder) {
      return AlertDialog (
        title:  const Text("Vill du ta bort fordonet?"),
        content: const Text(""),
        actions: [
          cancelButton,
          okButton,
        ],
      );
    }
  );

}