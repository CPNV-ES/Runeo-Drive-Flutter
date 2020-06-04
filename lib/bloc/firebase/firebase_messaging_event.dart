import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class FirebaseMessagingEvent extends Equatable {
  const FirebaseMessagingEvent();

  @override
  List<Object> get props => [];
}

class OnMessageEvent extends FirebaseMessagingEvent {

  @override
  List<Object> get props => null;
}