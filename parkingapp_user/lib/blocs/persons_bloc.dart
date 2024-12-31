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

final class CreatePerson extends PersonsEvent {
  final Person person;
  CreatePerson({required this.person});
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

final class CreatePersonSuccess extends PersonsState {
  final Person? user;
  CreatePersonSuccess({this.user});
}

final class UpdatePersonSuccess extends PersonsState {
  final Person? user;
  UpdatePersonSuccess({this.user}); 
}

final class DeletePersonSuccess extends PersonsState {
  final Person? user;
  DeletePersonSuccess({this.user});
}

final class GetPersonSuccess extends PersonsState {
  final Person? user;
  GetPersonSuccess({this.user});
}

final class GetAllPersonsSuccess extends PersonsState {
  final List<Person>? usersList;
  GetAllPersonsSuccess({ this.usersList });
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
              emit(GetPersonSuccess(user: user));
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
              emit(GetAllPersonsSuccess(usersList: usersList));
            } else {
              emit(PersonsError());
            }
          } catch(err) {
            emit(PersonsError());
          }

        case CreatePerson():
          try {
            var newUser = await PersonRepository().add(event.person);
            if(newUser != null) {
              emit(GetPersonSuccess(user: newUser));
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
              emit(UpdatePersonSuccess(user: updatedUser));
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
              emit(DeletePersonSuccess(user: deletedUser));
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

