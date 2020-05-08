import 'dart:async';

import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepositoryImpl userRepository;

  AuthenticationBloc({@required this.userRepository})
    : assert(userRepository != null);
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is LoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is LoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading(); // to display splash screen
    try {
      final bool currentUser = await userRepository.isAuthenticated();

      if (currentUser) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(LoggedIn event) async* {
    await userRepository.authenticate(key: event.token);
    yield AuthenticationAuthenticated();
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(LoggedOut event) async* {
    await userRepository.logOut();
    yield AuthenticationUnauthenticated();
  }
}
