part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String email;
  AuthLogin({required this.email});
}

final class AuthLogout extends AuthEvent {
  AuthLogout();
}