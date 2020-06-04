import 'package:equatable/equatable.dart';

abstract class StopwatchState extends Equatable {
  final String displayTimer;

  StopwatchState(this.displayTimer, [List<Object> props = const []]);
}

class Ready extends StopwatchState {
  Ready(String displayTimer) : super(displayTimer);

  @override
  List<Object> get props => [displayTimer];
}

class Running extends StopwatchState {  
  Running(String displayTimer) : super(displayTimer);

  @override
  List<Object> get props => [displayTimer];
}
