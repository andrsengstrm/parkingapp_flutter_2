import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';
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
          case CreateParking():
            var newParking = await repository!.create(Parking(vehicle: event.parking.vehicle, parkingSpace: event.parking.parkingSpace, startTime: event.parking.startTime));
            if(newParking != null) {
              var parkingsList = await repository!.readByVehicleOwnerEmail(newParking.vehicle!.owner!.email);
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError(error: "Error! Could not create parking"));
            }

          case ReadParkingById():
            var parking = await repository!.readById(event.id);
            if(parking != null) {
              emit(ParkingsSuccess(parkingsList: [parking]));
            } else {
              emit(ParkingsError(error: "Error! Could not read parking"));
            }

          case ReadParkingsByUser():
            emit(ParkingsLoading());
            var parkingsList = await repository!.readByVehicleOwnerEmail(event.user.email);
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError(error: "Error! Could not read parkings"));
            }

          case ReadAllParkings():
            emit(ParkingsLoading());
            var parkingsList = await repository!.read();
            if(parkingsList != null) {
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError(error: "Error! Could not read parkings"));
            }

          case UpdateParking():  
            var updatedParking = await repository!.update(event.parking.id, event.parking);
            if(updatedParking != null) {
              var parkingsList = await ParkingRepository().readByVehicleOwnerEmail(updatedParking.vehicle!.owner!.email);
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError(error: "Error! Could not update parking"));
            }
        
        }
      } catch(err) {
        emit(ParkingsError(error: "Error! ${err.toString()}"));
      }
    });
  }
}

