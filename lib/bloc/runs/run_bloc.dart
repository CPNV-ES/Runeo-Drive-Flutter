import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/repository/local_storage_repository.dart';
import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/repository/run_repository.dart';
import 'package:RuneoDriverFlutter/models/index.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final RunRepository runRepository;
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
      yield* _mapRunLoadedToState(event);
    }
    if (event is GetRunsFromStorageEvent) {
      yield* _mapRunLoadedFromLocalStorageToState(event);
    }
    if (event is TakeARunEvent) {
      yield* _mapTakeARunToState(event);
    }
    if (event is FilterUpdatedEvent) {
      yield* _mapFilteredRunsToState(event);
    }
  }

  Stream<RunState> _mapRunLoadedToState(GetRunsEvent event) async* {
    final List<Run> runs = await runRepository.getRuns();

    yield RunLoadingState();
    yield OnlineState();
    try {
      if (runs != null && runs.isNotEmpty) {
        yield RunLoadedState(runs: runs.where((run) => run.status != "unpublished" && run.status != "error").toList());
      } else {
        yield RunEmptyState();
      }
    } catch (e) {
      yield RunErrorState(message: e.toString());
    }
  }

  Stream<RunState> _mapRunLoadedFromLocalStorageToState(GetRunsFromStorageEvent event) async* {
    try {
      yield OfflineState();
    } catch (e) {
      yield RunErrorState(message: e.toString());
    }
  }

  Stream<RunState> _mapTakeARunToState(TakeARunEvent event) async* {
    try {
      final Run run = await runRepository.assignRunner(event.runner, event.updated_at);
      if (run != null) {
        yield AddRunnerSuccessState(run, message: "Successfully added runner to " + event.run.title + " run");
      } else {
        yield AddRunnerErrorState(message: "Error when adding a runner to " + event.run.title);
      }
      } catch (e) {
        yield OfflineState();
      }
  }

  Stream<RunState> _mapFilteredRunsToState(FilterUpdatedEvent event) async* {
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

  /// Filter runs.
  /// 
  /// Switch on [filter] to know what to return. return all the [runs] or the authenticated user [currentUserRuns]. 
  /// And default, return [runs] by the status of the run.
  List<Run> _mapRunsToFilteredRuns(
    List<Run> runs, List<Run> currentUserRuns, String filter) {
      switch (filter) {
        case "all":
          return runs.where((run) => run.status != "unpublished" && run.status != "error").toList();
          break;
        case "mine":
          return currentUserRuns;
          break;
        default:
          return runs.where((run) => run.status == filter).toList();
      }
    }

  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }
}
