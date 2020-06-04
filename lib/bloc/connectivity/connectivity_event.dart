import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class GetStatusInfo extends ConnectivityEvent {
  final ConnectivityResult result;

  GetStatusInfo({@required this.result});

  @override
  List<Object> get props => null;
}