import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/question_model.dart';

class ApiService {
  final String _baseUrl = 'https://the-trivia-api.com/api/questions';
  final Logger _logger = Logger();

  Future<List<Question>> fetchQuestions({
    int limit = 10,
    String difficulty = 'easy',
  }) async {
    try {
      final url = Uri.parse('$_baseUrl?limit=$limit&difficulty=$difficulty');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        if (decodedData is! List) {
          throw Exception('Invalid response format');
        }

        final List<dynamic> data = decodedData;
        return data.map((json) => Question.fromJson(json)).toList();
      } else {
        _logger.e('Failed to fetch questions: ${response.statusCode}');
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      _logger.e('Error fetching questions: $e');
      rethrow;
    }
  }
}
