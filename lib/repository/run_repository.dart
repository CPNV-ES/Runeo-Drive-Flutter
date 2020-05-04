import 'dart:convert';
import 'dart:io';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:http/http.dart' as http;

abstract class RunRepository {
  Future<List<Run>> getRuns();
}

class RunRepositoryImpl implements RunRepository {
	final String _baseUrl = 'http://127.0.0.1:8000/api';
	final String _apiToken = 'VA5PuxHGSYy5FnqX5enz1HUa9DtuQCQNyIl5LTxk5oViPEmGnQIo0Ef3qB1B';

	Future<List<Run>> getRuns() async {
		var response = await http.get(
			'$_baseUrl/runs',
			headers: {HttpHeaders.authorizationHeader: "Basic $_apiToken"}
		);

		if (response.statusCode == 200) {
			var data = json.decode(response.body);
			List<Run> runs = Run.fromJson(data).props;
			return runs;
		} else {
			throw Exception('error getting runs');
		}
	}
}