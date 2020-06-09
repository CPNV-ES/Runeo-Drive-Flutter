import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/index.dart';
import 'package:RuneoDriverFlutter/bloc/stopwatch/index.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final RunBloc _runBloc;
  final StopwatchBloc _stopwatchBloc;
  
  ConnectivityBloc({
    @required RunBloc runBloc,
    @required StopwatchBloc stopwatchBloc
  }) : assert(runBloc != null && stopwatchBloc != null),
      _runBloc = runBloc,
      _stopwatchBloc = stopwatchBloc;
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  ConnectivityState get initialState => ConnectivityInitial();

  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is GetStatusInfo){
      if (event.result == ConnectivityResult.none) {
        _runBloc.add(GetRunsFromStorageEvent());
      } else {
        _runBloc.add(GetRunsEvent());
        _stopwatchBloc.add(Start());
      }
    } 
  }
}
