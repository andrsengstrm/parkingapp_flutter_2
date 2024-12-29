import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

sealed class VehiclesEvent {}

final class GetVehiclesById extends VehiclesEvent {
  final int id;
  GetVehiclesById({required this.id});
}

final class GetVehiclesByOwner extends VehiclesEvent {
  final Person owner;
  GetVehiclesByOwner({required this.owner});
}

final class UpdateVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  UpdateVehicle({required this.vehicle});
}

final class DeleteVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  DeleteVehicle({required this.vehicle});
}

sealed class VehiclesState {}

final class VehiclesInitial extends VehiclesState {
  VehiclesInitial();
}

final class VehiclesLoading extends VehiclesState {
  VehiclesLoading();
}

final class VehiclesSuccess extends VehiclesState {
  final Vehicle? vehicle;
  final List<Vehicle>? vehiclesList;
  VehiclesSuccess({this.vehicle, this.vehiclesList});
}

final class VehiclesError extends VehiclesState {
  VehiclesError();
}

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc() : super(VehiclesInitial()) {
    on<VehiclesEvent>((event, emit) async {
      switch(event) {
        case GetVehiclesById():
          try {
            var vehicle = await VehicleRepository().getById(event.id);
            if(vehicle != null) {
              emit(VehiclesSuccess(vehicle: vehicle));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case GetVehiclesByOwner():
          try {
            var vehiclesList = await VehicleRepository().getByOwnerEmail(event.owner.email);
            if(vehiclesList != null) {
              emit(VehiclesSuccess(vehiclesList: vehiclesList));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case UpdateVehicle():
          // TODO: Handle this case.
        case DeleteVehicle():
          // TODO: Handle this case.
        
      }

    });
  }
}

