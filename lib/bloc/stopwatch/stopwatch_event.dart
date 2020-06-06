import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class Reset extends StopwatchEvent {

  @override
  List<Object> get props => null;
}

class Start extends StopwatchEvent {

  @override
  List<Object> get props => null;
}

class RunningTimer extends StopwatchEvent {

  @override
  List<Object> get props => null;
}