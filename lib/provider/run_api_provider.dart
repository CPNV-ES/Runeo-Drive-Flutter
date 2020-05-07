import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class RunApiProvider {
	final String _baseUrl = 'http://10.0.2.2:8000/api';
	final String _apiToken = 'VA5PuxHGSYy5FnqX5enz1HUa9DtuQCQNyIl5LTxk5oViPEmGnQIo0Ef3qB1B';

	Future<dynamic> get(String url) async {
		var response = await http.get(
			'$_baseUrl/$url',
			headers: {
				HttpHeaders.contentTypeHeader: "application/json", 
				HttpHeaders.authorizationHeader: "Bearer $_apiToken"
			});

		if (response.statusCode == 200) {
			List<dynamic> data = json.decode(response.body);
      return data;
		} else {
			throw Exception('error getting runs');
		}
	}
}