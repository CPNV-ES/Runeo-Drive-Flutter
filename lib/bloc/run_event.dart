import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RunEvent extends Equatable {
	const RunEvent();
}

class GetRunsEvent extends RunEvent {
	@override
	List<Object> get props => null;
}
