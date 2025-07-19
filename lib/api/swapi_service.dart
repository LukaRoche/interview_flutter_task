import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class SwapiService {
  final String _baseUrl = 'https://swapi.info/api/people/';
  final http.Client _client;

  // Add a constructor that allows injecting the client, so we can test it smoothly
  SwapiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Person>> getPeople() async {
    final response = await _client.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);

      final List<Person> people = results.map((personData) {
        final String url = personData['url'];
        final int id = int.parse(url.split('/')[5]);
        return Person.fromJson(personData as Map<String, dynamic>, id);
      }).toList();
      return people;
    } else {
      throw Exception('Failed to load people');
    }
  }

  Future<Person> getPersonDetails(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl$id/'));
    if (response.statusCode == 200) {
      return Person.fromJson(json.decode(response.body), id);
    } else {
      throw Exception('Failed to load person details');
    }
  }
}