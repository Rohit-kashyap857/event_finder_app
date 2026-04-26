import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class SavedService {
  static const String key = "saved_events";

  static Future<void> saveEvent(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];

    if (!saved.any((e) => jsonDecode(e)['id'] == event.id)) {
      saved.add(jsonEncode(event.toJson()));
      await prefs.setStringList(key, saved);
    }
  }

  static Future<void> removeEvent(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];

    saved.removeWhere((e) => jsonDecode(e)['id'] == id);
    await prefs.setStringList(key, saved);
  }

  static Future<List<Event>> getSavedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];

    return saved.map((e) => Event.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> isSaved(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(key) ?? [];

    return saved.any((e) => jsonDecode(e)['id'] == id);
  }
}