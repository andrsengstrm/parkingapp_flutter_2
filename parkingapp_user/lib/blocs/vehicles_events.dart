part of 'vehicles_bloc.dart';

sealed class VehiclesEvent {}

final class CreateVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  CreateVehicle({required this.vehicle});
}

final class ReadVehiclesById extends VehiclesEvent {
  final int id;
  ReadVehiclesById({required this.id});
}

final class ReadVehiclesByOwnerEmail extends VehiclesEvent {
  final Person user;
  ReadVehiclesByOwnerEmail({required this.user});
}

final class UpdateVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  UpdateVehicle({required this.vehicle});
}

final class DeleteVehicle extends VehiclesEvent {
  final Vehicle vehicle;
  DeleteVehicle({required this.vehicle});
}