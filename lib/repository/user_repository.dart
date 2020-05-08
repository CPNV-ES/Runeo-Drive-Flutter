import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:RuneoDriverFlutter/provider/api_provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> authenticate();
  Future<User> getCurrentUser();
  Future<void> _deleteFromStorage(String key);
  Future<void> _saveToStorage(String key, dynamic value);
  Future<bool> _isAuthenticated();
  Future _barcodeScanning();
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
    return response;
  }

  Future<User> getCurrentUser() async {
    return await this.storage.getItem("currentUser");
  }

  Future<void> _deleteFromStorage(String key) async {
    /// delete from keystore/keychain
    await this.storage.deleteItem(key);
    return;
  }

  Future<void> _saveToStorage(String key, dynamic value) async {
    /// write to keystore/keychain
    await this.storage.setItem("token", value);
    return;
  }

  Future<bool> _isAuthenticated() async {
    /// read from keystore/keychain
    String value = await this.storage.getItem("token");
    if (value != null) {
      return true;
    }
    return false;
  }

  Future _barcodeScanning() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      return barcode.rawContent;
    } catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return barcode.type;
      } else {
        return 'Unknown error: $e' as ScanResult;
      }
    } on FormatException {
      return barcode.formatNote;
    } catch (e) {
      return 'Unknown error: $e';
    }
  }
}