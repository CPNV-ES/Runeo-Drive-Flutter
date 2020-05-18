import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class ApiProvider {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  LocalStorage storage;

  ApiProvider() {
    this.storage = new LocalStorage('runeo_drive');
  }

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

  Future<dynamic> getUser() async {
    final value = await this.storage.getItem("token");
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
}