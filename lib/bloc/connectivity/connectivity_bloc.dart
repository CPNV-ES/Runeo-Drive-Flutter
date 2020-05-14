import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/bloc/connectivity/index.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final RunBloc _runBloc;
  
  ConnectivityBloc({
    @required RunBloc runBloc
  }) : assert(runBloc != null),
      _runBloc = runBloc;
  
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
      }
    } 
  }
}
