part of 'persons_bloc.dart';

sealed class PersonsEvent {}

final class CreatePerson extends PersonsEvent {
  final Person person;
  CreatePerson({required this.person});
}

final class ReadPersonById extends PersonsEvent {
  final int id;
  ReadPersonById({required this.id});
}

final class UpdatePerson extends PersonsEvent {
  final Person person;
  UpdatePerson({required this.person});
}

final class DeletePerson extends PersonsEvent {
  final Person person;
  DeletePerson({required this.person});
}
