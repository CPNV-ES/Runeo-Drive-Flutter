import 'package:barcode_scan/barcode_scan.dart';
import 'package:meta/meta.dart';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';
import 'package:RuneoDriverFlutter/repository/local_storage_repository.dart';

abstract class UserRepository {
  Future<User> authenticate();
  Future<User> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<void> logOut();
  Future<String> barcodeScanning();
}

class UserRepositoryImpl implements UserRepository {
  ScanResult barcode;
  ApiProvider _provider = ApiProvider();
  LocalStorageRepositoryImpl _localStorageRepository = LocalStorageRepositoryImpl();
  User currentUser;

  Future<User> authenticate({
    @required String key,
  }) async {
    _localStorageRepository.saveToStorage("token", key);
    final response = await _provider.getUser();
    if (response != null) {
      final User user = User.fromJson(response);
      _localStorageRepository.saveToStorage("currentUser", user);      
      return user;
    }
    return response;
  }

  Future<User> getCurrentUser() async {
    var value = await _provider.storage.getItem("currentUser");
    if (value != null) {
      this.currentUser = value;
      return User.fromJson(value);
    }
    return value;   
  }

  Future<bool> isAuthenticated() async {
    /// read from keystore/keychain
    var value = await this.getCurrentUser();
    if (value != null) {
      return true;
    }
    return false;
  }

  Future<void> logOut() async {
    _localStorageRepository.deleteFromStorage("token");
    _localStorageRepository.deleteFromStorage("currentUser");
  }

  Future<String> barcodeScanning() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      return barcode.rawContent;
    } catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return 'Access to the camera has been denied!';
      } else {
        return 'Unknown error: $e';
      }
    } on FormatException {
      return 'Not the right format!';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }
}