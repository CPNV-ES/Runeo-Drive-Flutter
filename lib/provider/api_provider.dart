import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import 'package:RuneoDriverFlutter/models/index.dart';

class ApiProvider {
  final String _baseUrl = DotEnv().env['API_URL'];
  LocalStorage storage;

  ApiProvider() {
    this.storage = new LocalStorage('runeo_drive');
  }

  /// GET runs.
  /// 
  /// Return all the runs as a dynamic [data]. 
  /// Throws and Exception when [response.statusCode] is not equal to 200 and when there is no internet connection.
  Future<dynamic> getRuns() async {
    final value = await this.storage.getItem("token");
    try {
      var response = await http.get(
      '$_baseUrl/runs',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json", 
        HttpHeaders.authorizationHeader: "Bearer $value"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('error fetching data');
      }
    } catch (e, stackTrace) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      }
    }
  }

  /// GET authenticated user.
  /// 
  /// Return user as a dynamic [data]. 
  /// Throws and Exception when [response.statusCode] is not equal to 200 and when there is no internet connection.
  Future<dynamic> getUser() async {
    final value = await this.storage.getItem("token");
    /// Get firebase token
    final valueFirebaseToken = await this.storage.getItem("firebaseToken");
    print("firebase token : $valueFirebaseToken");
    try {
      var response = await http.get(
      '$_baseUrl/me',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json", 
        HttpHeaders.authorizationHeader: "Bearer $value"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('error fetching data');
      }
    } catch (e, stackTrace) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      }
    }
  }

  /// GET authenticated user runs.
  /// 
  /// Return all the runs from the authenticated user as a dynamic [data]. 
  /// Throws and Exception when [response.statusCode] is not equal to 200 and when there is no internet connection.
  Future<dynamic> getUserRuns() async {
    final value = await this.storage.getItem("token");
    try {
      var response = await http.get(
      '$_baseUrl/me/runs',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json", 
        HttpHeaders.authorizationHeader: "Bearer $value"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('error fetching data');
      }
    } catch (e, stackTrace) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      }
    }
  }

  /// PATCH a runner to a run.
  /// 
  /// Pass the [runners] and the [updatedAt] of a run.
  /// Return the run that has been updated as a dynamic [data]. 
  /// Throws and Exception when [response.statusCode] is not equal to 200, when there is no internet connection and catch all the other Exceptions.
  Future<dynamic> setRunner(List<Runner> runners, String updatedAt) async {
    final value = await this.storage.getItem("token");
    final runRunner = runners.first;
    try {
      var response = await http.patch(
      '$_baseUrl/runners/' + runRunner.id.toString() + '/driver',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $value"
      },
      body: {"updated_at": updatedAt});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('error patching data');
      }
    } catch (e, stackTrace) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else {
        throw Exception(e);
      }
    }
  }
}