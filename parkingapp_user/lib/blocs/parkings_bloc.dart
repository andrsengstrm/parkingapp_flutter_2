import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';
import 'package:parkingapp_user/repositories/parking_space_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

sealed class ParkingsEvent {}

final class GetParkingById extends ParkingsEvent {
  final int id;
  GetParkingById({ required this.id });
}

final class GetParkingsByUser extends ParkingsEvent {
  final Person user;
  GetParkingsByUser({ required this.user });
}

final class GetAllParkings extends ParkingsEvent {
  GetAllParkings();
}

final class StartParking extends ParkingsEvent {
  final Parking parking;
  StartParking(this.parking);
}

final class EndParking extends ParkingsEvent {
  final Parking parking;
  final String endTime;
  EndParking(this.parking, this.endTime);
}

sealed class ParkingsState {}

final class ParkingsInitial extends ParkingsState {
  ParkingsInitial();
}

final class ParkingsLoading extends ParkingsState {
  ParkingsLoading();
}

final class ParkingsSuccess extends ParkingsState {
  Parking? parking;
  List<Parking>? parkingsList;
  ParkingsSuccess({this.parking, this.parkingsList});
}

final class ParkingsError extends ParkingsState {
  ParkingsError();
} 

class ParkingsBloc extends Bloc<ParkingsEvent, ParkingsState>{
  ParkingsBloc() : super(ParkingsInitial()) {
    on<ParkingsEvent>((event, emit) async {
      switch(event) {
        case GetParkingById():
          try {
            var parking = await ParkingRepository().getById(event.id);
            if(parking != null) {
              List<Parking> parkingsList = [parking];
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }

        case GetParkingsByUser():
          try {
            var parkingsList = await ParkingRepository().getAllByVehicleOwnerEmail(event.user.email!);
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }

        case GetAllParkings():
          try {
            var parkingsList = await ParkingRepository().getAll();
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }
          
        case StartParking():
          try {
            var newParking = await ParkingRepository().add(Parking(vehicle: event.parking.vehicle, parkingSpace: event.parking.parkingSpace, startTime: event.parking.startTime));
            if(newParking != null) {
              emit(ParkingsSuccess(parking: newParking));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }

        case EndParking():  
          try {
            var endedParking = await ParkingRepository().update(event.parking.id, event.parking);
            if(endedParking != null) {
              List<Parking> parkingsList = [endedParking];
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }
        
      }

    });
  }
}

