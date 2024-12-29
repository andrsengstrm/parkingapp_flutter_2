import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

sealed class PersonsEvent {}

final class GetPersonById extends PersonsEvent {
  final int id;
  GetPersonById({required this.id});
}

final class GetAllPersons extends PersonsEvent {
  GetAllPersons();
}

final class UpdatePerson extends PersonsEvent {
  final Person person;
  UpdatePerson({required this.person});
}

final class DeletePerson extends PersonsEvent {
  final Person person;
  DeletePerson({required this.person});
}

sealed class PersonsState {}

final class PersonsInitial extends PersonsState {}

final class PersonsLoading extends PersonsState {}

final class PersonsSuccess extends PersonsState {
  final Person? user;
  final List<Person>? usersList;
  PersonsSuccess({ this.user, this.usersList });
}

final class PersonsError extends PersonsState {}

class PersonsBloc extends Bloc<PersonsEvent, PersonsState> {
  PersonsBloc(): super(PersonsInitial()) {
    on<PersonsEvent>((event, emit) async {
      switch (event) {
        case GetPersonById():
          try {
            var user = await PersonRepository().getById(event.id);
            if(user != null) {
              emit(PersonsSuccess(user: user));
            } else {
              emit(PersonsError());
            }
          } catch(err) {
            emit(PersonsError());
          }

        case GetAllPersons():
          try {
            var usersList = await PersonRepository().getAll();
            if(usersList != null) {
              emit(PersonsSuccess(usersList: usersList));
            } else {
              emit(PersonsError());
            }
          } catch(err) {
            emit(PersonsError());
          }

        case UpdatePerson():
          try {
            var updatedUser = await PersonRepository().update(event.person.id, event.person);
            if(updatedUser != null) {
              emit(PersonsSuccess(user: updatedUser));
            } else {
              emit(PersonsError());
            }
          } catch(err) {
            emit(PersonsError());
          }  
        
        case DeletePerson():
          try {
            var deletedUser = await PersonRepository().delete(event.person.id);
            if(deletedUser != null) {
              emit(PersonsSuccess(user: deletedUser));
            } else {
              emit(PersonsError());
            }
          } catch(err) {
            emit(PersonsError());
          }  
        
       
      }
    });
  }
}

