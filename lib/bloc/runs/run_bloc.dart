import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/repository/local_storage_repository.dart';
import 'package:RuneoDriverFlutter/repository/user_repository.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/repository/run_repository.dart';
import 'package:RuneoDriverFlutter/models/index.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final RunRepository runRepository;
  UserRepositoryImpl _userRepository = UserRepositoryImpl();
  LocalStorageRepositoryImpl _localStorageRepository = LocalStorageRepositoryImpl();

  RunBloc({
    @required this.runRepository
  }): assert(runRepository != null);

  @override
  RunState get initialState => RunInitalState();

  @override
  Stream<RunState> mapEventToState(
    RunEvent event,
  ) async* {
    if (event is GetRunsEvent) {
      final List<Run> runs = await runRepository.getRuns();
      yield RunLoadingState();
      yield OnlineState();
      try {
        yield RunLoadedState(runs: runs);
      } catch (e) {
        yield RunErrorState(message: e.toString());
      }
    } else if (event is GetRunsFromStorageEvent) {
      try {
        yield OfflineState();
      } catch (e) {
        yield RunErrorState(message: e.toString());
      }
    } else if (event is FilterUpdated) {
      yield RunLoadingState();
      try {
        final User user = await _userRepository.getCurrentUser();
        final List<Run> runs = await _localStorageRepository.getRunsFromStorage();
        yield RunLoadedState(runs: _mapRunsToFilteredRuns(runs, event.filter, user), activeFilter: event.filter);
      } catch (e) {
        yield RunErrorState(message: e.toString());
      }
    }
  }

  List<Run> _mapRunsToFilteredRuns(
    List<Run> runs, String filter, User user) {
    if (filter == "all") {
      return runs;
    } else if (filter == "mine") {
      runs.forEach((run) {
        return run.runners.where((runner) => runner.user != null && runner.user.id == user.id).toList();
      });
    } else {
      return runs.where((run) => run.status == filter).toList();
    }
  }

  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }
}
