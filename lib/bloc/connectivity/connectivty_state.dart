import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityOnline extends ConnectivityState {}

class ConnectivityOffline extends ConnectivityState {}
