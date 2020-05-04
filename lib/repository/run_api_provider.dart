import 'dart:convert';
import 'dart:io';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class RunApiProvider {
	final String _baseUrl = 'http://127.0.0.1:8000/api';
	final String _apiToken = 'VA5PuxHGSYy5FnqX5enz1HUa9DtuQCQNyIl5LTxk5oViPEmGnQIo0Ef3qB1B';

	Future<Run> getRuns() async {
		var response = await http.get(
			'$_baseUrl/runs',
			headers: {HttpHeaders.authorizationHeader: "Basic $_apiToken"}
		);

		if (response.statusCode == 200) {
			var data = json.decode(response.body);
			return Run.fromJson(data);
		} else {
			throw Exception('error getting runs');
		}
	}
}