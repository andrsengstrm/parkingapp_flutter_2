import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

part 'auth_events.dart';
part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late PersonRepository? repository;
  AuthBloc({this.repository}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        repository ??= PersonRepository();
        switch(event) {
          case AuthLogin():
            emit(AuthInProgess());
            var person = await repository!.readByEmail(event.email);
            if(person != null) {
              emit(AuthSuccess(user: person));
            } else {
              emit(AuthError(error: "Det finns inget konto, kontrollera användarnamn och lösenord."));
            }
 
          case AuthLogout():
            emit(AuthInitial());
        
        }
      } catch(err) {
        emit(AuthError(error: "Det gick inte att logga in, prova igen"));
      }

    });
  }
  
}



