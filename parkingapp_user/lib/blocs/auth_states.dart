part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

final class AuthInitial extends AuthState {
  AuthInitial();
  
  @override
  List<Object?> get props => [];
}

final class AuthInProgess extends AuthState {
  AuthInProgess();

  @override
  List<Object?> get props => [];
}

final class AuthSuccess extends AuthState {
  final Person? user;
  AuthSuccess({this.user});

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final String? error;
  AuthError({this.error});

  @override
  List<Object?> get props => [];
}