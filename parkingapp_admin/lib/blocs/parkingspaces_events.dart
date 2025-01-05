part of 'parkingspaces_bloc.dart';

sealed class ParkingSpacesEvent {}

final class CreateParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;
  CreateParkingSpace({ required this.parkingSpace });
}

final class ReadParkingSpaceById extends ParkingSpacesEvent {
  final int id;
  ReadParkingSpaceById({required this.id});
}

final class ReadAllParkingSpaces extends ParkingSpacesEvent {
  ReadAllParkingSpaces();
}

final class UpdateParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;
  UpdateParkingSpace({ required this.parkingSpace });
}

final class DeleteParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;
  DeleteParkingSpace({ required this.parkingSpace });
}