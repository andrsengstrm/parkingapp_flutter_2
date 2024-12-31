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

final class GetParkingSpaceByIdSuccess extends ParkingSpacesState {
  final ParkingSpace? parkingSpace;
  GetParkingSpaceByIdSuccess({ this.parkingSpace });
}

final class GetAllParkingSpacesSuccess extends ParkingSpacesState {
  final List<ParkingSpace>? parkingSpacesList;
  GetAllParkingSpacesSuccess({ this.parkingSpacesList });
}

final class UpdateParkingSpaceSuccess extends ParkingSpacesState {
  final ParkingSpace? parkingSpace;
  UpdateParkingSpaceSuccess({ this.parkingSpace });
}

final class DeleteParkingSpaceSuccess extends ParkingSpacesState {
  final ParkingSpace? parkingSpace;
  DeleteParkingSpaceSuccess({ this.parkingSpace });
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
              emit(GetParkingSpaceByIdSuccess(parkingSpace: parkingSpace));
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
              emit(GetAllParkingSpacesSuccess(parkingSpacesList: parkingSpacesList));
            } else {
              emit(ParkingSpacesError());
            }
          } catch(err) {
            emit(ParkingSpacesError());
          }

        case UpdateParkingSpace():
          try {
            var updatedParkingSpace = await ParkingSpaceRepository().update(event.parkingSpace.id, event.parkingSpace);
            if(updatedParkingSpace != null) {
              emit(UpdateParkingSpaceSuccess(parkingSpace: updatedParkingSpace));
            } else {
              emit(ParkingSpacesError());
            }
          } catch(err) {
            emit(ParkingSpacesError());
          }
          
        case DeleteParkingSpace():
          try {
            var deletedParkingSpace = await ParkingSpaceRepository().update(event.parkingSpace.id, event.parkingSpace);
            if(deletedParkingSpace != null) {
              emit(DeleteParkingSpaceSuccess(parkingSpace: deletedParkingSpace));
            } else {
              emit(ParkingSpacesError());
            }
          } catch(err) {
            emit(ParkingSpacesError());
          }
          
      }
    });
  }

}