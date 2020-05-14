import 'package:RuneoDriverFlutter/enums/connectivity_status.dart';
import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class GetStatusInfo extends ConnectivityEvent {
  final ConnectivityStatus result;

  GetStatusInfo({@required this.result});

	@override
	List<Object> get props => null;
}