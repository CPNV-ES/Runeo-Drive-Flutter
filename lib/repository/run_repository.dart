import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';
import 'package:RuneoDriverFlutter/repository/local_storage_repository.dart';


abstract class RunRepository {
  Future<List<Run>> getRuns();
  Future<List<Run>> getUserRuns();
  Future<Run> assignRunner(List<Runner> runners, String updatedAt);
}

class RunRepositoryImpl implements RunRepository {
  ApiProvider _provider = ApiProvider();
  LocalStorageRepositoryImpl _localStorageRepository = LocalStorageRepositoryImpl();

  /// Get runs from API.
  /// 
  /// Return all the [runs] as a list<Run>. Stores the runs in local storage.
  Future<List<Run>> getRuns() async {
    final List<Run> runs = [];
    var response = await _provider.getRuns();
    response.forEach((run) {
      runs.add(Run.fromJson(run));
    });
    _localStorageRepository.saveToStorage("runs", response);
    
    return runs;
  }

  /// Get authenticated user runs.
  /// 
  /// Return all the [runs] as a list<Run>.
  Future<List<Run>> getUserRuns() async {
    final List<Run> runs = [];
    var response = await _provider.getUserRuns();
    response.forEach((run) {
      runs.add(Run.fromJson(run));
    });

    return runs;
  }

  /// Assign a runner to a run.
  /// 
  /// We need to give him the [runners] of a run and the [updatedAt] of a run.
  /// Return the updated [run].
  Future<Run> assignRunner(List<Runner> runners, String updatedAt) async {
    var response = await _provider.setRunner(runners, updatedAt);
    final Run run = Run.fromJson(response);

    return run;
  }
}