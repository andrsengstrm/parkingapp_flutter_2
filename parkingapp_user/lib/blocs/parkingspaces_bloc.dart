import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/parking_space_repository.dart';
import 'package:shared/models/parking_space.dart';

sealed class ParkingSpacesEvent {}

final class GetParkingSpaceById extends ParkingSpacesEvent {
  final int id;
  GetParkingSpaceById({required this.id});
}

final class GetAllParkingSpaces extends ParkingSpacesEvent {
  GetAllParkingSpaces();
}

final class UpdateParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;
  UpdateParkingSpace({ required this.parkingSpace });
}

final class DeleteParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;
  DeleteParkingSpace({ required this.parkingSpace });
}

sealed class ParkingSpacesState {}

final class ParkingSpacesInitial extends ParkingSpacesState {
  ParkingSpacesInitial ();
}

final class ParkingSpacesLoading extends ParkingSpacesState {
  ParkingSpacesLoading();
}

final class ParkingSpacesSuccess extends ParkingSpacesState {
  final ParkingSpace? parkingSpace;
  final List<ParkingSpace>? parkingSpacesList;
  ParkingSpacesSuccess({ this.parkingSpace, this.parkingSpacesList });
}

final class ParkingSpacesError extends ParkingSpacesState {
  ParkingSpacesError();
}

final class ParkingSpacesBloc extends Bloc<ParkingSpacesEvent, ParkingSpacesState> {
  ParkingSpacesBloc(): super(ParkingSpacesInitial()) {
    on<ParkingSpacesEvent>((event, emit) async {
      switch(event) {
        case GetParkingSpaceById():
          try {
            var parkingSpace = await ParkingSpaceRepository().getById(event.id);
            if(parkingSpace != null) {
              emit(ParkingSpacesSuccess(parkingSpace: parkingSpace));
            } else {
              emit(ParkingSpacesError());
            }
          } catch(err) {
            emit(ParkingSpacesError());
          }

        case GetAllParkingSpaces():
          try {
            var parkingSpacesList = await ParkingSpaceRepository().getAll();
            if(parkingSpacesList != null) {
              emit(ParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }
          } catch(err) {
            emit(ParkingSpacesError());
          }

        case UpdateParkingSpace():
          // TODO: Handle this case.
        case DeleteParkingSpace():
          // TODO: Handle this case.
      }
    });
  }

}