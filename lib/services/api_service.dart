import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class ApiService {
  static const String url =
      "https://mocki.io/v1/0a8b2c6e-4c8a-4c6a-9f2b-123456789abc";

  static Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          return decoded.map((e) => Event.fromJson(e)).toList();
        } else if (decoded is Map && decoded.containsKey('data')) {
          return (decoded['data'] as List)
              .map((e) => Event.fromJson(e))
              .toList();
        } else {
          throw Exception("Invalid JSON format");
        }
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      return await loadLocalEvents();
    }
  }
  static Future<List<Event>> loadLocalEvents() async {
    final String response =
    await rootBundle.loadString('assets/data/events.json');

    final List data = json.decode(response);

    return data.map((e) => Event.fromJson(e)).toList();
  }
}