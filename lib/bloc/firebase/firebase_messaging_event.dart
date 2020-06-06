import 'package:equatable/equatable.dart';

abstract class FirebaseMessagingEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class OnMessageEvent extends FirebaseMessagingEvent {
  final Map<String, dynamic> message;

  OnMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}