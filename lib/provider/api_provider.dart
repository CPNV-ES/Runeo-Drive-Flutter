import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class ApiProvider {
	final String _baseUrl = 'http://10.0.2.2:8000/api';
  final storage = new LocalStorage('runeo_drive');
	String _apiToken;
  
  ApiProvider() {
    this._apiToken = storage.getItem("token");
  }

	Future<dynamic> get(String url) async {
		var response = await http.get(
			'$_baseUrl/$url',
			headers: {
				HttpHeaders.contentTypeHeader: "application/json", 
				HttpHeaders.authorizationHeader: "Bearer $_apiToken"
			});

		if (response.statusCode == 200) {
			final data = json.decode(response.body);
      return data;
		} else {
			throw Exception('error getting runs');
		}
	}
}