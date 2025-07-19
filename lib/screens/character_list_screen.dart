import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:interview_flutter_task/state/app_state.dart';
import '../state/character_provider.dart';
import '../widgets/character_tile.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterProvider>(context, listen: false).fetchPeople();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Star Wars Characters'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
      body: Consumer<CharacterProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case AppState.loading:
              return const Center(child: CircularProgressIndicator());
            case AppState.error:
              return Center(child: Text(provider.errorMessage));
            case AppState.loaded:
              return ListView.builder(
                itemCount: provider.people.length,
                itemBuilder: (context, index) {
                  final person = provider.people[index];
                  return CharacterTile(person: person);
                },
              );
            default:
              return const Center(child: Text('Press button to load data'));
          }
        },
      ),
    );
  }
}