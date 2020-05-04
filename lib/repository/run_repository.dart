import 'dart:convert';
import 'dart:io';

import 'package:RuneoDriverFlutter/models/index.dart';
import 'package:http/http.dart' as http;

abstract class RunRepository {
	Future<List<Run>> getRuns();
}

class RunRepositoryImpl implements RunRepository {
	final String _baseUrl = 'http://10.0.2.2:8000/api';
	final String _apiToken = 'VA5PuxHGSYy5FnqX5enz1HUa9DtuQCQNyIl5LTxk5oViPEmGnQIo0Ef3qB1B';

	Future<List<Run>> getRuns() async {
		final List<Run> runs = [];
		var response = await http.get(
			'$_baseUrl/runs',
			headers: {
				HttpHeaders.contentTypeHeader: "application/json", 
				HttpHeaders.authorizationHeader: "Bearer $_apiToken"
			});

		if (response.statusCode == 200) {
			List<dynamic> data = json.decode(response.body);
			data.forEach((run) {
				runs.add(Run.fromJson(run));
			});
			return runs;
		} else {
			throw Exception('error getting runs');
		}
	}
}