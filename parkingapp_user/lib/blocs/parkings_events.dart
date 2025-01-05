part of 'parkings_bloc.dart';

sealed class ParkingsEvent {}

final class ReadParkingById extends ParkingsEvent {
  final int id;
  ReadParkingById({ required this.id });
}

final class ReadParkingsByUser extends ParkingsEvent {
  final Person user;
  ReadParkingsByUser({ required this.user });
}

final class ReadAllParkings extends ParkingsEvent {
  ReadAllParkings();
}

final class CreateParking extends ParkingsEvent {
  final Parking parking;
  CreateParking({required this.parking});
}

final class UpdateParking extends ParkingsEvent {
  final Parking parking;
  UpdateParking({required this.parking});
}