import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_admin/repositories/parking_space_repository.dart';
import 'package:shared/models/parking_space.dart';

part 'parkingspaces_events.dart';
part 'parkingspaces_state.dart';

final class ParkingSpacesBloc extends Bloc<ParkingSpacesEvent, ParkingSpacesState> {
  late ParkingSpaceRepository? repository;
  ParkingSpacesBloc({this.repository}): super(ParkingSpacesInitial()) {
    on<ParkingSpacesEvent>((event, emit) async {
      try {
        repository ??= ParkingSpaceRepository();
        switch(event) {
          case CreateParkingSpace():
            var newParkingSpace = await repository!.create(event.parkingSpace);
            if(newParkingSpace != null) {
              var parkingSpacesList = await repository!.read();
              emit(ParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }

          case ReadParkingSpaceById():
            var parkingSpace = await repository!.readById(event.id);
            if(parkingSpace != null) {
              emit(ParkingSpacesSuccess(parkingSpacesList: [parkingSpace]));
            } else {
              emit(ParkingSpacesError());
            }

          case ReadAllParkingSpaces():
            var parkingSpacesList = await repository!.read();
            if(parkingSpacesList != null) {
              emit(ParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }

          case UpdateParkingSpace():
            var updatedParkingSpace = await repository!.update(event.parkingSpace.id, event.parkingSpace);
            if(updatedParkingSpace != null) {
              var parkingSpacesList = await repository!.read();
              emit(ParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }
          
          case DeleteParkingSpace():
            var deletedParkingSpace = await repository!.delete(event.parkingSpace.id);
            if(deletedParkingSpace != null) {
              var parkingSpacesList = await repository!.read();
              emit(ParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }
          
        }
      } catch(err) {
        emit(ParkingSpacesError());
      }
    });
  }

}