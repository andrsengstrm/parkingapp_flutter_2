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

final class GetParkingByIdSuccess extends ParkingsState {
  Parking? parking;
  GetParkingByIdSuccess({this.parking});
}

final class GetParkingsByUserSuccess extends ParkingsState {
  List<Parking>? parkingsList;
  GetParkingsByUserSuccess({this.parkingsList});
}

final class GetAllParkingsSuccess extends ParkingsState {
  List<Parking>? parkingsList;
  GetAllParkingsSuccess({this.parkingsList});
}

final class StartParkingSuccess extends ParkingsState {
  Parking? parking;
  StartParkingSuccess({this.parking});
}

final class UpdateParkingSuccess extends ParkingsState {
  Parking? parking;
  UpdateParkingSuccess({this.parking});
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
              emit(GetParkingByIdSuccess(parking: parking));
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
              emit(GetParkingsByUserSuccess(parkingsList: parkingsList));
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
              emit(GetAllParkingsSuccess(parkingsList: parkingsList));
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
              emit(StartParkingSuccess(parking: newParking));
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
              emit(UpdateParkingSuccess(parking: updatedParking));
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

