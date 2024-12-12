import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

//enum AuthEvent { login, logout }

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

final class AuthSuccess extends AuthState {
  final Person user;
  AuthSuccess(this.user);
}

final class AuthInProgess extends AuthState {
  AuthInProgess();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      switch(event) {
        case AuthLogin():
          emit(AuthInProgess());
          var person = await PersonRepository().getByEmail(event.email);
          if(person != null) {
            emit(AuthSuccess(person));
          } else {
            emit(AuthFailure(""));
          }
        case AuthLogout():
          emit(AuthInitial());
      }
    });
  }
  
}



