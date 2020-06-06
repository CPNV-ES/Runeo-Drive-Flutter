import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;

  LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {}