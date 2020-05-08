import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/bloc/runs/index.dart';
import 'package:RuneoDriverFlutter/repository/run_repository.dart';
import 'package:RuneoDriverFlutter/models/index.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
	final RunRepository repository;

	RunBloc({
		@required this.repository
	}): assert(repository != null);

	@override
	RunState get initialState => RunInitalState();

	@override
	Stream<RunState> mapEventToState(
		RunEvent event,
	) async* {
		if (event is GetRunsEvent) {
      final List<Run> runs = await repository.getRuns();
			yield RunLoadingState();
			try {			
				yield RunLoadedState(runs: runs);
			} catch (e) {
				yield RunErrorState(message: e.toString());
			}
		} else if (event is FilterUpdated) {
      yield RunLoadingState();
			try {
        final List<Run> runs = await repository.getRuns();
				yield RunLoadedState(runs: _mapRunsToFilteredRuns(runs, event.filter), activeFilter: event.filter);
			} catch (e) {
				yield RunErrorState(message: e.toString());
			}
    }
	}

  List<Run> _mapRunsToFilteredRuns(
    List<Run> runs, String filter) {
    if (filter == "all") {
      return runs;
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
