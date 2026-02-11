import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/question_model.dart';

class ApiService {
  final String _baseUrl = 'https://the-trivia-api.com/v2/questions';
  final Logger _logger = Logger();

  Future<List<Question>> fetchQuestions({
    int limit = 10,
    String difficulty = 'easy',
  }) async {
    try {
      final url = Uri.parse('$_baseUrl?limit=$limit&difficulties=$difficulty');
      _logger.i('Fetching questions from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
