import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/bloc/index.dart';
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
		if (event is GetRuns) {
			yield RunLoadingState();
			try {
				final List<Run> runs = await repository.getRuns();
				yield RunLoadedState(runs: runs);
			} catch (e) {
				yield RunErrorState(message: e.toString());
			}
		}
		
	}
}
