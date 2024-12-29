import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String email;
  AuthLogin(this.email);
}

final class AuthLogout extends AuthEvent {
  AuthLogout();
}

sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthInProgess extends AuthState {
  AuthInProgess();
}

final class AuthSuccess extends AuthState {
  final Person user;
  AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch(event) {
        case AuthLogin():
        try {
          emit(AuthInProgess());
          //await Future.delayed(const Duration(milliseconds: 1000));
          var person = await PersonRepository().getByEmail(event.email);
          debugPrint(person.toString());
          if(person != null) {
            emit(AuthSuccess(person));
          } else {
            emit(AuthFailure(error: "Det finns inget konto, kontrollera användarnamn och lösenord."));
          }
        } catch(err) {
          emit(AuthFailure(error: "Det gick inte att logga in, prova igen"));
        }
          
        case AuthLogout():
          emit(AuthInitial());
      } 
    });
  }
  
}



