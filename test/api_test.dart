import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:interview_flutter_task/models/person.dart';
import 'package:mockito/mockito.dart';
import 'package:interview_flutter_task/api/swapi_service.dart';

// This is the line that will generate the Mocks class
@GenerateMocks([http.Client])
import 'api_test.mocks.dart';

void main() {
  group('SwapiService', () {
    late SwapiService swapiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      swapiService = SwapiService(client: mockClient);
    });

    test('getPeople returns a list of Person on success', () async {
      // Mock the successful response
      when(mockClient.get(Uri.parse('https://swapi.info/api/people/')))
          .thenAnswer((_) async => http.Response(
        '[{"name": "Luke Skywalker", "url": "https://swapi.info/api/people/1/"}]',
        200,
      ));

      // Call the service method
      final people = await swapiService.getPeople();

      // Verify the result
      expect(people, isA<List<Person>>());
      expect(people.length, 1);
      expect(people[0].name, 'Luke Skywalker');
      expect(people[0].id, 1);
    });

    test('getPeople throws an exception on HTTP error', () {
      when(mockClient.get(Uri.parse('https://swapi.info/api/people/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await swapiService.getPeople(), throwsException);
    });

    test('getPersonDetails returns a Person on success', () async {
      when(mockClient.get(Uri.parse('https://swapi.info/api/people/1/')))
          .thenAnswer((_) async => http.Response(
        '{"name": "Luke Skywalker", "birth_year": "19BBY", "url": "https://swapi.info/api/people/1/"}',
        200,
      ));

      final person = await swapiService.getPersonDetails(1);

      expect(person, isA<Person>());
      expect(person.id, 1);
      expect(person.name, 'Luke Skywalker');
      expect(person.birthYear, '19BBY');
    });

    test('getPersonDetails throws an exception on HTTP error', () {
      when(mockClient.get(Uri.parse('https://swapi.info/api/people/99/')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await swapiService.getPersonDetails(99),
          throwsException);
    });
  });
}