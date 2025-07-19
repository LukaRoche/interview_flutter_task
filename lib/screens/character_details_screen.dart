import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/swapi_service.dart';
import '../models/person.dart';
import '../providers/character_provider.dart'; // Import providera

class CharacterDetailsScreen extends StatefulWidget {
  final int personId;

  const CharacterDetailsScreen({super.key, required this.personId});

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late Future<Person> _personDetailsFuture;
  final SwapiService _swapiService = SwapiService();

  @override
  void initState() {
    super.initState();
    _personDetailsFuture = _swapiService.getPersonDetails(widget.personId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        actions: [
          Consumer<CharacterProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.personId);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  provider.toggleFavorite(widget.personId);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Person>(
        future: _personDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final person = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    border: TableBorder.all(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    children: [
                      _buildTableRow('Birth Year:', person.birthYear ?? 'N/A'),
                      _buildTableRow('Gender:', person.gender ?? 'N/A'),
                      _buildTableRow('Hair Color:', person.hairColor ?? 'N/A'),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}