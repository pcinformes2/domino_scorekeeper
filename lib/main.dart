import 'package:flutter/material.dart';

void main() {
  runApp(const DominoApp());
}

// Main App
class DominoApp extends StatelessWidget {
  const DominoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domino Scorekeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domino Scorekeeper'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('New Game'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GameSetupScreen()),
            );
          },
        ),
      ),
    );
  }
}

// Game Setup Screen
enum GameMode { individual, teams }

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  GameMode _mode = GameMode.teams;
  int _maxScore = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Game Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<GameMode>(
              title: const Text('Teams (2 vs 2)'),
              value: GameMode.teams,
              groupValue: _mode,
              onChanged: (value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
            RadioListTile<GameMode>(
              title: const Text('Individual Players'),
              value: GameMode.individual,
              groupValue: _mode,
              onChanged: (value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Max Score',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<int>(
              title: const Text('100 points'),
              value: 100,
              groupValue: _maxScore,
              onChanged: (value) {
                setState(() {
                  _maxScore = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: const Text('200 points'),
              value: 200,
              groupValue: _maxScore,
              onChanged: (value) {
                setState(() {
                  _maxScore = value!;
                });
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                child: const Text('Start Game'),
                onPressed: () {
                  print('Mode: $_mode, MaxScore: $_maxScore');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Selected Mode: $_mode, Max Score: $_maxScore'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
