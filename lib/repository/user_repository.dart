import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> authenticate();
  Future<User> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<void> logOut();
  Future<String> barcodeScanning();
  Future<void> _deleteFromStorage(String key);
  Future<void> _saveToStorage(String key, dynamic value);
}

class UserRepositoryImpl implements UserRepository {
  ScanResult barcode;
  ApiProvider _provider = ApiProvider();
  LocalStorage storage;

  UserRepositoryImpl() {
    this.storage = _provider.storage;
  }

  Future<User> authenticate({
    @required String key,
  }) async {
    this._saveToStorage("token", key);
    final response = await _provider.get("me");
    this._saveToStorage("currentUser", User.fromJson(response));
    return User.fromJson(response);
  }

  Future<User> getCurrentUser() async {
    return await this.storage.getItem("currentUser");
  }

  Future<bool> isAuthenticated() async {
    /// read from keystore/keychain
    var value = await this.storage.getItem("currentUser");
    if (value != null) {
      return true;
    }
    return false;
  }

  Future<void> logOut() async {
    this._deleteFromStorage("token");
    this._deleteFromStorage("currentUser");
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

  Future<void> _deleteFromStorage(String key) async {
    /// delete from keystore/keychain
    return await this.storage.deleteItem(key);
  }

  Future<void> _saveToStorage(String key, dynamic value) async {
    /// write to keystore/keychain
    return await this.storage.setItem(key, value);
  }
}