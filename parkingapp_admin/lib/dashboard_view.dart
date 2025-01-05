import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/blocs/parkings_bloc.dart';
import 'package:parkingapp_admin/blocs/parkingspaces_bloc.dart';
import 'package:shared/models/parking_space.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  
  @override
  Widget build(BuildContext context) {

    context.read<ParkingsBloc>().add(ReadAllParkings());
    context.read<ParkingSpacesBloc>().add(ReadAllParkingSpaces());

    return Container (
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Dashboard", style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActiveParkingsCount(),
              _TotalParkingsCount(),
            ]
          ),
          Row(
            children: [
              _FreeParkingSpacesCount(),
              _TotalParkingSpacesCount()
            ],
          ),
          _TotalParkingsEarnings()
        ],
      )
    );
  }

}

class _ActiveParkingsCount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var parkingsState = context.watch<ParkingsBloc>().state;
    switch(parkingsState) {
      case ParkingsSuccess(parkingsList: var parkingsList):
        return activeParkingsCount(context, parkingsList);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget activeParkingsCount(BuildContext context, parkingsList) {
    var activeParkingsCount = parkingsList.where((p) => p.endTime == null);
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Antal aktiva parkeringar"),
            Text(activeParkingsCount.length.toString(), style: const TextStyle(fontSize: 42))
          ],
        ),
      ),
    );
  }

}


class _TotalParkingsCount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var parkingsState = context.watch<ParkingsBloc>().state;
    switch(parkingsState) {
      case ParkingsSuccess(parkingsList: var parkingsList):
        return totalParkingsCount(context, parkingsList);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget totalParkingsCount(BuildContext context, parkingsList) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Totalt antal parkeringar"),
            Text(parkingsList.length.toString(), style: TextStyle(fontSize: 42))
          ],
        ),
      ),
    );
  }
  
}


class _FreeParkingSpacesCount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final parkingSpacesState = context.watch<ParkingSpacesBloc>().state;
    switch(parkingSpacesState) {
      case ParkingSpacesSuccess(parkingSpacesList: var parkingSpacesList):
        final parkingsState = context.watch<ParkingsBloc>().state;
        switch(parkingsState) {
          case ParkingsSuccess(parkingsList: var parkingsList):
             return freeParkingSpacesCount(context, parkingSpacesList, parkingsList);
          default:
            return const SizedBox.shrink();
        }
      default:
        return const SizedBox.shrink();
    }
  }

  Widget freeParkingSpacesCount(BuildContext context, parkingSpacesList, parkingsList) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Antal lediga parkeringar"),
            Text(getAvaibleParkingSpaces(parkingsList, parkingSpacesList).length.toString(), style: const TextStyle(fontSize: 42))
          ],
        ),
      ),
    );
  }

  List<ParkingSpace> getAvaibleParkingSpaces(parkingsList, parkingSpacesList) {
      var activeParkingsList = parkingsList.where((p) => p.endTime == null).toList();
      var busyParkings = [];
      for(var i = 0; i < activeParkingsList!.length; i++) {
        var parking = activeParkingsList[i];
        if(parking.endTime == null) {
          if(!busyParkings.contains(parking.parkingSpace!.id)) {
            busyParkings.add(parking.parkingSpace!.id);
          }
        }
      }

      List<ParkingSpace>? availableParkingSpaces = [];
      for(var i = 0; i < parkingSpacesList!.length; i++) {
        var parkingSpace = parkingSpacesList[i];
        if(!busyParkings.contains(parkingSpace.id)) {
          availableParkingSpaces.add(parkingSpace);
        }
      }

      return availableParkingSpaces;
    }
  
} 


class _TotalParkingSpacesCount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final parkingSpacesState = context.watch<ParkingSpacesBloc>().state;
    switch(parkingSpacesState) {
      case ParkingSpacesSuccess(parkingSpacesList: var parkingSpacesList):
        return totalParkingSpacesCount(context, parkingSpacesList);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget totalParkingSpacesCount(BuildContext context, parkingSpacesList) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Totalt antal parkeringar"),
            Text(parkingSpacesList.length.toString(), style: const TextStyle(fontSize: 42))
          ],
        ),
      ),
    );
  }
  
} 


class _TotalParkingsEarnings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var parkingsState = context.watch<ParkingsBloc>().state;
    switch(parkingsState) {
      case ParkingsSuccess(parkingsList: var parkingsList):
        return totalParkingsEarnings(context, parkingsList);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget totalParkingsEarnings(BuildContext context, parkingsList) {
    num cost = 0;
    for(var i = 0; i < parkingsList!.length; i++) {
        var parking = parkingsList[i];
        cost += double.tryParse(parking.getCostForParking()) != null ? double.parse(parking.getCostForParking()): 0;
      }

    return Container(
      width: 616,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Total intäkt"),
          Text("${cost.toStringAsFixed(2)} kr", style: const TextStyle(fontSize: 42))
        ],
      ),
    );
  }

}