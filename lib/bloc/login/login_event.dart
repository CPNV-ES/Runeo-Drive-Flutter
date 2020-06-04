import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInButtonPressed extends LoginEvent {
  final String token;
  final String firebaseToken;

  LoginInButtonPressed({
    @required this.token,
    @required this.firebaseToken
  });

  @override
  List<Object> get props => [token, firebaseToken];
}