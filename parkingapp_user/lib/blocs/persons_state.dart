part of 'persons_bloc.dart';

sealed class PersonsState extends Equatable {}

final class PersonsInitial extends PersonsState {
  @override
  List<Object?> get props => [];
}

final class PersonsLoading extends PersonsState {
  @override
  List<Object?> get props => [];
}

final class PersonsSuccess extends PersonsState {
  final Person? user;
  PersonsSuccess({ this.user });
  
  @override
  List<Object?> get props => [user];
}

final class PersonsError extends PersonsState {
  @override
  List<Object?> get props => [];
}