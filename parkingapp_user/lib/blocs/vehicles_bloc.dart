import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

sealed class VehiclesEvent {}

final class GetVehiclesById extends VehiclesEvent {
  final int id;
  GetVehiclesById({required this.id});
}

final class GetVehiclesByUser extends VehiclesEvent {
  final Person user;
  GetVehiclesByUser({required this.user});
}

final class AddVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  AddVehicle({required this.vehicle});
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

final class GetVehicleByIdSuccess extends VehiclesState {
  final Vehicle? vehicle;
  GetVehicleByIdSuccess({this.vehicle});
}

final class GetVehiclesByUserSuccess extends VehiclesState {
  final List<Vehicle>? vehiclesList;
  GetVehiclesByUserSuccess({this.vehiclesList});
}

final class AddVehicleSuccess extends VehiclesState {
  final Vehicle? vehicle;
  AddVehicleSuccess({this.vehicle});
}

final class UpdateVehicleSuccess extends VehiclesState {
  final Vehicle? vehicle;
  UpdateVehicleSuccess({this.vehicle});
}

final class DeleteVehicleSuccess extends VehiclesState {
  final Vehicle? vehicle;
  DeleteVehicleSuccess({this.vehicle});
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
              emit(GetVehicleByIdSuccess(vehicle: vehicle));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case GetVehiclesByUser():
          try {
            var vehiclesList = await VehicleRepository().getByOwnerEmail(event.user.email);
            if(vehiclesList != null) {
              emit(GetVehiclesByUserSuccess(vehiclesList: vehiclesList));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case AddVehicle():
          try {
            var vehicle = await VehicleRepository().add(event.vehicle);
            if(vehicle != null) {
              emit(AddVehicleSuccess(vehicle: vehicle)); 
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case UpdateVehicle():
          try {
            var vehicle = await VehicleRepository().update(event.vehicle.id, event.vehicle);
            if(vehicle != null) {
              emit(UpdateVehicleSuccess(vehicle: vehicle));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        case DeleteVehicle():
          try {
            var vehicle = await VehicleRepository().delete(event.vehicle.id);
            if(vehicle != null) {
              emit(DeleteVehicleSuccess(vehicle: vehicle));
            } else {
              emit(VehiclesError());
            }
          } catch(err) {
            emit(VehiclesError());
          }

        
        
      }

    });
  }
}

