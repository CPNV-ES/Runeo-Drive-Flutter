import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';
import 'package:RuneoDriverFlutter/repository/local_storage_repository.dart';


abstract class RunRepository {
	Future<List<Run>> getRuns();
}

class RunRepositoryImpl implements RunRepository {
	ApiProvider _provider = ApiProvider();
  LocalStorageRepositoryImpl _localStorageRepository = LocalStorageRepositoryImpl();

	Future<List<Run>> getRuns() async {
		final List<Run> runs = [];
    var response = await _provider.getRuns();
    response.forEach((run) {
      runs.add(Run.fromJson(run));
    });
    _localStorageRepository.saveToStorage("runs", response);
		
		return runs;
	}
}