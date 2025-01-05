import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/person.dart';

part 'parkings_events.dart';
part 'parkings_state.dart';

class ParkingsBloc extends Bloc<ParkingsEvent, ParkingsState>{
  late ParkingRepository? repository;
  ParkingsBloc({this.repository}) : super(ParkingsInitial()) {
    on<ParkingsEvent>((event, emit) async {
      try {
        repository ??= ParkingRepository();
        switch(event) {
          case ReadParkingById():       
            var parking = await repository!.readById(event.id);
            if(parking != null) {
              emit(ParkingsSuccess(parkingsList: [parking]));
            } else {
              emit(ParkingsError());
            }

          case ReadParkingsByUser():
            var parkingsList = await repository!.readByVehicleOwnerEmail(event.user.email);
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }

          case ReadAllParkings():
            var parkingsList = await repository!.read();
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          
          case CreateParking():
            var newParking = await repository!.create(Parking(vehicle: event.parking.vehicle, parkingSpace: event.parking.parkingSpace, startTime: event.parking.startTime));
            if(newParking != null) {
              var parkingsList = await repository!.read();
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }

          case UpdateParking():  
            var updatedParking = await repository!.update(event.parking.id, event.parking);
            if(updatedParking != null) {
              var parkingsList = await repository!.read();
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
        
        }
      } catch(err) {
        emit(ParkingsError());
      }

    });
  }
}

