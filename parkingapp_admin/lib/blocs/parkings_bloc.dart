import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/person.dart';

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

final class UpdateParking extends ParkingsEvent {
  final Parking parking;
  UpdateParking(this.parking);
}

sealed class ParkingsState {}

final class ParkingsInitial extends ParkingsState {
  ParkingsInitial();
}

final class ParkingsLoading extends ParkingsState {
  ParkingsLoading();
}

final class ParkingsSuccess extends ParkingsState {
  List<Parking>? parkingsList;
  ParkingsSuccess({this.parkingsList});
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
            var parking = await ParkingRepository().readById(event.id);
            if(parking != null) {
              emit(ParkingsSuccess(parkingsList: [parking]));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }

        case GetParkingsByUser():
          try {
            var parkingsList = await ParkingRepository().readByVehicleOwnerEmail(event.user.email!);
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
            var parkingsList = await ParkingRepository().read();
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
            var newParking = await ParkingRepository().create(Parking(vehicle: event.parking.vehicle, parkingSpace: event.parking.parkingSpace, startTime: event.parking.startTime));
            if(newParking != null) {
              var parkingsList = await ParkingRepository().read();
              emit(ParkingsSuccess(parkingsList: parkingsList));
            } else {
              emit(ParkingsError());
            }
          } catch(err) {
            emit(ParkingsError());
          }

        case UpdateParking():  
          try {
            var updatedParking = await ParkingRepository().update(event.parking.id, event.parking);
            if(updatedParking != null) {
              var parkingsList = await ParkingRepository().read();
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

