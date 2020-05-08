import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInButtonPressed extends LoginEvent {
  final String token;

  LoginInButtonPressed({@required this.token});

  @override
  List<Object> get props => [token];
}
