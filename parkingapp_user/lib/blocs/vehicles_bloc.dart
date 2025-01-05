import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

part 'vehicles_events.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  late VehicleRepository? repository;
  VehiclesBloc({this.repository}) : super(VehiclesInitial()) {
    on<VehiclesEvent>((event, emit) async {
      try {
        repository ??= VehicleRepository();
        switch(event) {
          case CreateVehicle():
            var vehicle = await repository!.create(event.vehicle);
            if(vehicle != null) {
              var vehiclesList = await repository!.readByOwnerEmail(vehicle.owner?.email);
              emit(VehiclesSuccess(vehiclesList: vehiclesList)); 
            } else {
              emit(VehiclesError());
            }

          case ReadVehiclesById():
            var vehicle = await repository!.readById(event.id);
            if(vehicle != null) {
              emit(VehiclesSuccess(vehiclesList: [vehicle]));
            } else {
              emit(VehiclesError());
            }

          case ReadVehiclesByOwnerEmail():
            var vehiclesList = await repository!.readByOwnerEmail(event.user.email);
            if(vehiclesList != null) {
              emit(VehiclesSuccess(vehiclesList: vehiclesList));
            } else {
              emit(VehiclesError());
            }

          case UpdateVehicle():
            var vehicle = await repository!.update(event.vehicle.id, event.vehicle);
            if(vehicle != null) {
              var vehiclesList = await repository!.readByOwnerEmail(vehicle.owner?.email);
              emit(VehiclesSuccess(vehiclesList: vehiclesList)); 
            } else {
              emit(VehiclesError());
            }

          case DeleteVehicle():
            var vehicle = await repository!.delete(event.vehicle.id);
            if(vehicle != null) {
              var vehiclesList = await repository!.readByOwnerEmail(vehicle.owner?.email);
              emit(VehiclesSuccess(vehiclesList: vehiclesList)); 
            } else {
              emit(VehiclesError());
            }
        
        }
      } catch(err) {
        emit(VehiclesError());
      }

    });
  }
}

