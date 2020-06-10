import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:timeago/timeago.dart'as timeago;
import 'package:time/time.dart';

import 'package:RuneoDriverFlutter/bloc/stopwatch/index.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  Stopwatch watch;
  Duration _currentDuration = Duration.zero;
  DateTime _lastRefreshTimer = 0.minutes.fromNow;
  String _displayTimer;

  StopwatchBloc() {
    watch = new Stopwatch();
    // Add a new locale messages
    timeago.setLocaleMessages('fr', timeago.FrMessages());
  }

  @override
  StopwatchState get initialState => Ready("");

  @override
  Stream<StopwatchState> mapEventToState(
    StopwatchEvent event,
  ) async* {
    if (event is Start) {
      yield* _mapStartToState();
    }
    if (event is RunningTimer) {
      yield* _mapUpdateToState();
    }
  }

  Stream<StopwatchState> _mapStartToState() async* {
    yield Ready(_displayTimer);
    watch.start();
    _currentDuration = watch.elapsed;
    _lastRefreshTimer = _currentDuration.fromNow;
    yield Running(_displayTimer);
  }

  Stream<StopwatchState> _mapUpdateToState() async* {
    updateTime(_lastRefreshTimer);
    yield Running(_displayTimer);
  }

  /// Update display text
  void updateTime(DateTime lastRefreshTimer) {
    if (watch.isRunning) {
      _displayTimer = timeago.format(lastRefreshTimer, locale: 'fr');
    } else {
      _displayTimer = timeago.format(lastRefreshTimer, locale: 'fr');
    }
  }

  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }
}
