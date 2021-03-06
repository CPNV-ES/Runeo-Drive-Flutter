import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';

abstract class LocalStorageRepository {
  Future<dynamic> getRunsFromStorage();
  Future<dynamic> getUserRunsFromStorage();
  Future<void> deleteFromStorage(String key);
  Future<void> saveToStorage(String key, dynamic value);
}

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  ApiProvider _provider = ApiProvider();

  /// Get runs from local storage.
  /// 
  /// Return all the [runs] as a list<Run>.
  Future<dynamic> getRunsFromStorage() async {
    final List<Run> runs = [];
    var response = await _provider.storage.getItem("runs");
    response.forEach((run) {
      runs.add(Run.fromJson(run));
    });
    return runs;
  }

  /// Get authenticated user runs from local storage.
  /// 
  /// Return all the [runs] as a list<Run>.
  Future<dynamic> getUserRunsFromStorage() async {
    final List<Run> runs = [];
    var response = await _provider.storage.getItem("userRuns");
    response.forEach((run) {
      runs.add(Run.fromJson(run));
    });
    return runs;
  }

  /// Delete [key] in local storage.
  Future<void> deleteFromStorage(String key) async {
    /// delete from keystore/keychain
    return await _provider.storage.deleteItem(key);
  }

  /// Insert [key] and [value] to local storage.
  Future<void> saveToStorage(String key, dynamic value) async {
    /// write to keystore/keychain
    return await _provider.storage.setItem(key, value);
  }
}