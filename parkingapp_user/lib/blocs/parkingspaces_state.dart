part of 'parkingspaces_bloc.dart';

sealed class ParkingSpacesState extends Equatable {}

final class ParkingSpacesInitial extends ParkingSpacesState {
  ParkingSpacesInitial ();
  
  @override
  List<Object?> get props => [];
}

final class ParkingSpacesLoading extends ParkingSpacesState {
  ParkingSpacesLoading();

  @override
  List<Object?> get props => [];
}

final class ParkingSpacesSuccess extends ParkingSpacesState {
  final List<ParkingSpace>? parkingSpacesList;
  ParkingSpacesSuccess({ this.parkingSpacesList });

  @override
  List<Object?> get props => [parkingSpacesList];
}

final class ParkingSpacesError extends ParkingSpacesState {
  ParkingSpacesError();
  
  @override
  List<Object?> get props => [];
}