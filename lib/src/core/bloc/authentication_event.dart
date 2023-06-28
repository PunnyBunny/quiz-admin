part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {
  final bool isAdmin;
  LoginRequested({required this.isAdmin});
}

class LogoutRequested extends AuthenticationEvent {}
