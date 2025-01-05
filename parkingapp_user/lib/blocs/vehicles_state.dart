part of 'vehicles_bloc.dart';

sealed class VehiclesState extends Equatable {}

final class VehiclesInitial extends VehiclesState {
  VehiclesInitial();
  
  @override
  List<Object?> get props => [];
}

final class VehiclesLoading extends VehiclesState {
  VehiclesLoading();

  @override
  List<Object?> get props => [];
}

final class VehiclesSuccess extends VehiclesState {
  final List<Vehicle>? vehiclesList;
  VehiclesSuccess({this.vehiclesList});

  @override
  List<Object?> get props => [vehiclesList];
}

final class VehiclesError extends VehiclesState {
  VehiclesError();

  @override
  List<Object?> get props => [];
}
