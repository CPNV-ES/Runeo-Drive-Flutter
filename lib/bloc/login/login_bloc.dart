import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/bloc/authentication/index.dart';
import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:RuneoDriverFlutter/bloc/login/index.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepositoryImpl _userRepository;
  final AuthenticationBloc _authenticationBloc;

  LoginBloc({
    @required AuthenticationBloc authenticationBloc,
    @required UserRepositoryImpl userRepository,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc,
        _userRepository = userRepository;
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginInitial();
    if (event is LoginInButtonPressed) {
      yield LoginLoading();

      try {
        final currentUser = await _userRepository.authenticate(
          key: event.token,
          
          firebaseToken: event.firebaseToken
        );
        if (currentUser != null) {
          // push new authentication event
          _authenticationBloc.add(LoggedIn(user: currentUser));
          yield LoginSuccess();
        } else {
          yield LoginFailure(error: "It's not the right token");
        }
      } on Exception catch (err) {
        yield LoginFailure(error: '$err' ?? 'An unknown error occured');
      }
    }
  }
}
