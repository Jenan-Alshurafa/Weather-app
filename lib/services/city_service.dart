// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CityService {
  // Get API keys from environment variables
  static String get _apiKey => dotenv.env['RAPIDAPI_KEY'] ?? '';
  static String get _host =>
      dotenv.env['RAPIDAPI_HOST'] ?? 'wft-geo-db.p.rapidapi.com';

  static Future<List<dynamic>> searchCities(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'RAPIDAPI_KEY is not configured. Please check your .env file.',
      );
    }

    final url = Uri.parse(
      'https://$_host/v1/geo/cities?namePrefix=$query&limit=5',
    );

    try {
      final response = await http.get(
        url,
        headers: {'x-rapidapi-key': _apiKey, 'x-rapidapi-host': _host},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final citiesList = data['data'] as List<dynamic>?;
        if (citiesList != null && citiesList.isNotEmpty) {
          return citiesList;
        } else {
          return [];
        }
      } else if (response.statusCode == 401) {
        final errorBody = response.body;
        throw Exception(
          'Invalid API key (401). Please check:\n'
          '1. Your RapidAPI key is correct\n'
          '2. You have subscribed to "GeoDB Cities" API on RapidAPI\n'
          '3. The key has no extra spaces or quotes\n'
          'Response: $errorBody',
        );
      } else if (response.statusCode == 403) {
        throw Exception(
          'API access forbidden. Check your RapidAPI subscription.',
        );
      } else if (response.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else {
        throw Exception(
          'Failed to load cities (Status: ${response.statusCode}). ${response.body}',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    // Get API key from environment variables
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception(
        'OPENWEATHER_API_KEY is not configured. Please check your .env file.',
      );
    }

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
      '?lat=$lat&lon=$lon&units=metric&lang=ar&appid=$apiKey',
    );

    try {
      print(
        'Fetching weather from: ${url.toString().replaceAll(apiKey, '***HIDDEN***')}',
      );
      final response = await http.get(url);
      print('Weather API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        final errorBody = response.body;
        throw Exception(
          'Invalid OpenWeatherMap API key (401).\n'
          'Possible reasons:\n'
          '1. API key is incorrect or has typos\n'
          '2. New API key may take up to 2 hours to activate\n'
          '3. API key might be suspended or expired\n'
          '4. Check your API key at: https://home.openweathermap.org/api_keys\n'
          'Response: $errorBody',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Weather data not found for this location.');
      } else {
        throw Exception(
          'Failed to load weather (Status: ${response.statusCode}). ${response.body}',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
