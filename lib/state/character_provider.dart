import 'package:flutter/material.dart';
import 'package:interview_flutter_task/constants.dart';
import 'package:interview_flutter_task/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/swapi_service.dart';
import '../models/person.dart';

class CharacterProvider extends ChangeNotifier {
  final SwapiService _swapiService = SwapiService();

  List<Person> _people = [];
  List<Person> get people => _people;

  AppState _state = AppState.initial;
  AppState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<int> _favoriteIds = [];

  CharacterProvider() {
    _loadFavorites();
  }

  bool isFavorite(int personId) {
    return _favoriteIds.contains(personId);
  }

  void toggleFavorite(int personId) {
    if (isFavorite(personId)) {
      _favoriteIds.remove(personId);
    } else {
      _favoriteIds.add(personId);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // we parse list of ints to list of strings, so we can save it
    List<String> favoritesList = _favoriteIds.map((number) => number.toString()).toList();
    await prefs.setStringList(Constants.keyFavoriteIds,favoritesList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // we parse back list of strings to list of ints
    List<String> favoritesList = prefs.getStringList(Constants.keyFavoriteIds) ?? [];
    _favoriteIds = favoritesList
        .map((str) => int.tryParse(str))
        .whereType<int>()
        .toList();
    notifyListeners();
  }

  Future<void> fetchPeople() async {
    _state = AppState.loading;
    notifyListeners();
    try {
      _people = await _swapiService.getPeople();
      _state = AppState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AppState.error;
    }
    notifyListeners();
  }
}