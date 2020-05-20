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
    } else if (event is TakeARun) {
      try {
        final Run run = await runRepository.assignRunner(event.runner, event.updated_at);
        if (run != null) {
          yield AddRunnerSuccessState(run, message: "Successfully added runner to " + event.run.title + " run");
        } else {
          yield AddRunnerSuccessState(run, message: "Error when adding a runner to " + event.run.title);
        }

      } catch (e) {
        yield RunErrorState(message: e.toString());
        yield OfflineState();
      }
    } else if (event is FilterUpdated) {
      yield RunLoadingState();
      try {
        final List<Run> runs = await runRepository.getRuns();
        final List<Run> currentUserRuns = await runRepository.getUserRuns();
        yield OnlineState();
        yield RunLoadedState(runs: _mapRunsToFilteredRuns(runs, currentUserRuns, event.filter), activeFilter: event.filter);
      } catch (e) {
        final List<Run> runs = await _localStorageRepository.getRunsFromStorage();
        final List<Run> currentUserRuns = await _localStorageRepository.getUserRunsFromStorage();
        yield OfflineState();
        yield RunLoadedState(runs: _mapRunsToFilteredRuns(runs, currentUserRuns, event.filter), activeFilter: event.filter);
      }
    }
  }

  List<Run> _mapRunsToFilteredRuns(
    List<Run> runs, List<Run> currentUserRuns, String filter) {
    if (filter == "all") {
      return runs;
    } else if (filter == "mine") {
      return currentUserRuns;
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
