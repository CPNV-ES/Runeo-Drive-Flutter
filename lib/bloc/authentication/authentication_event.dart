import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;

  const LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {}