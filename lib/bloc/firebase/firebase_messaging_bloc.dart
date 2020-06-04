import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/bloc/firebase/index.dart';

class ConnectivityBloc extends Bloc<FirebaseMessagingEvent, FirebaseMessagingState> {
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
  FirebaseMessagingState get initialState => FirebaseMessagingInitial();

  @override
  Stream<FirebaseMessagingState> mapEventToState(FirebaseMessagingEvent event) async* {
    
  }
}
