import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

@immutable
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
  final String activeFilter;

	RunLoadedState({
		this.runs,
    this.activeFilter
	});

	@override
	List<Object> get props => [runs, activeFilter];
}

class RunErrorState extends RunState {
	String message;

  RunErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}