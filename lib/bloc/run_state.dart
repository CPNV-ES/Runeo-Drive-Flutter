import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

abstract class RunState extends Equatable {}

class RunInitalState extends RunState {
	@override
	List<Object> get props => [];
}

class RunLoadingState extends RunState {
	@override
	List<Object> get props => [];
}

class RunLoadedState extends RunState {
	final List<Run> runs;

	RunLoadedState({
		@required this.runs
	}): assert(runs != null);

	@override
	List<Object> get props => [runs];
}

class RunErrorState extends RunState {
	String message;

  RunErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
