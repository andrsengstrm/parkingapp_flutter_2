part of 'parkings_bloc.dart';

sealed class ParkingsState extends Equatable {}

final class ParkingsInitial extends ParkingsState {
  ParkingsInitial();
  
  @override
  List<Object?> get props => [];
}

final class ParkingsLoading extends ParkingsState {
  ParkingsLoading();

  @override
  List<Object?> get props => [];
}

final class ParkingsSuccess extends ParkingsState {
  final List<Parking>? parkingsList;
  ParkingsSuccess({this.parkingsList});

  @override
  List<Object?> get props => [parkingsList];
}

final class ParkingsError extends ParkingsState {
  ParkingsError();

  @override
  List<Object?> get props => [];
}