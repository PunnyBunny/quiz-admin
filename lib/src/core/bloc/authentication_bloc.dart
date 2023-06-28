import 'package:bloc/bloc.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.unauthenticated) {
    on<LoginRequested>((event, emit) {
      if (event.isAdmin) {
        emit(AuthenticationState.authenticatedAdmin);
      } else {
        emit(AuthenticationState.authenticatedUser);
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(AuthenticationState.unauthenticated);
    });
  }
}
