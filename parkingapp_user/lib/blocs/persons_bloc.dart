import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

part 'persons_events.dart';
part 'persons_state.dart';

class PersonsBloc extends Bloc<PersonsEvent, PersonsState> {
  late PersonRepository? repository;
  PersonsBloc({this.repository}): super(PersonsInitial()) {
    on<PersonsEvent>((event, emit) async {
      try {
        repository ??= PersonRepository();
        switch (event) {
          case CreatePerson():
            var newUser = await repository!.create(event.person);
            if(newUser != null) {
              emit(PersonsSuccess(user: newUser));
            } else {
              emit(PersonsError());
            } 
            
          case ReadPersonById():
            var user = await repository!.readById(event.id);
            if(user != null) {
              emit(PersonsSuccess(user: user));
            } else {
              emit(PersonsError());
            } 
            emit(PersonsSuccess(user: user)); 

          case UpdatePerson():
              var updatedUser = await repository!.update(event.person.id, event.person);
              if(updatedUser != null) {
                emit(PersonsSuccess(user: updatedUser));
              } else {
                emit(PersonsError());
              }
          
          case DeletePerson():
              var deletedUser = await repository!.delete(event.person.id);
              emit(PersonsSuccess(user: deletedUser));

        }
      } catch(err) {
        emit(PersonsError());
      }
    });
  }
}

