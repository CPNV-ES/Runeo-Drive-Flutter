import 'package:equatable/equatable.dart';

abstract class FirebaseMessagingState extends Equatable {
  const FirebaseMessagingState();

  @override
  List<Object> get props => [];
}

class FirebaseMessagingInitial extends FirebaseMessagingState {}
