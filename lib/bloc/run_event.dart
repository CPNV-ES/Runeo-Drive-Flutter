import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RunEvent extends Equatable {
	const RunEvent();
}

class GetRuns extends RunEvent {
	const GetRuns();

	@override
	List<Object> get props => [];
}
