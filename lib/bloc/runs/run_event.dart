import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

@immutable
abstract class RunEvent extends Equatable {
  const RunEvent();
}

class GetRunsEvent extends RunEvent {
  @override
  List<Object> get props => null;
}

class GetRunsFromStorageEvent extends RunEvent {
  @override
  List<Object> get props => null;
}

class FilterUpdatedEvent extends RunEvent {
  final String filter;

  const FilterUpdatedEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class TakeARunEvent extends RunEvent {
  final List<Runner> runner;
  final Run run;
  final String updated_at;

  const TakeARunEvent(this.run, this.runner, this.updated_at);

  @override
  List<Object> get props => [run, runner, updated_at];
}

