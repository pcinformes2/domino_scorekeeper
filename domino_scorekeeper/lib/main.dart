import 'package:flutter/material.dart';

void main() {
  runApp(const DominoScoreApp());
}

enum GameMode { teams, individual }

class DominoScoreApp extends StatefulWidget {
  const DominoScoreApp({super.key});

  @override
  State<DominoScoreApp> createState() => _DominoScoreAppState();
}

class _DominoScoreAppState extends State<DominoScoreApp> {
  bool gameStarted = false;

  GameMode mode = GameMode.teams;
  int maxScore = 100;
  int playerCount = 2;

  void startGame(GameMode m, int max, int players) {
    setState(() {
      mode = m;
      maxScore = max;
      playerCount = players;
      gameStarted = true;
    });
  }

  void resetGame() {
    setState(() {
      gameStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domino Web',
      home: gameStarted
          ? GameScreen(
        mode: mode,
        maxScore: maxScore,
        playerCount: playerCount,
        onReset: resetGame,
      )
          : SetupScreen(onStart: startGame),
    );
  }
}

/* ===================== SETUP SCREEN ===================== */

class SetupScreen extends StatefulWidget {
  final Function(GameMode, int, int) onStart;

  const SetupScreen({super.key, required this.onStart});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  GameMode mode = GameMode.teams;
  int maxScore = 100;
  int players = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Domino Web2')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Game Mode'),
            RadioListTile(
              title: const Text('Teams (2 vs 2)'),
              value: GameMode.teams,
              groupValue: mode,
              onChanged: (v) => setState(() => mode = v!),
            ),
            RadioListTile(
              title: const Text('Individual'),
              value: GameMode.individual,
              groupValue: mode,
              onChanged: (v) => setState(() => mode = v!),
            ),
            if (mode == GameMode.individual)
              DropdownButton<int>(
                value: players,
                items: const [
                  DropdownMenuItem(value: 2, child: Text('2 Players')),
                  DropdownMenuItem(value: 3, child: Text('3 Players')),
                ],
                onChanged: (v) => setState(() => players = v!),
              ),
            const SizedBox(height: 20),
            const Text('Max Score'),
            DropdownButton<int>(
              value: maxScore,
              items: const [
                DropdownMenuItem(value: 100, child: Text('100')),
                DropdownMenuItem(value: 200, child: Text('200')),
              ],
              onChanged: (v) => setState(() => maxScore = v!),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () =>
                  widget.onStart(mode, maxScore, players),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== GAME SCREEN ===================== */

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final int maxScore;
  final int playerCount;
  final VoidCallback onReset;

  const GameScreen({
    super.key,
    required this.mode,
    required this.maxScore,
    required this.playerCount,
    required this.onReset,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> players;
  late List<Color> colors;
  List<List<int>> rounds = [];

  @override
  void initState() {
    super.initState();

    if (widget.mode == GameMode.teams) {
      players = ['US', 'THEM'];
      colors = [Colors.blue, Colors.red];
    } else {
      players = List.generate(
          widget.playerCount, (i) => 'P${i + 1}');
      colors = [Colors.green, Colors.orange, Colors.purple];
    }
  }

  List<int> totals() {
    return List.generate(players.length, (i) {
      return rounds.fold(0, (sum, r) => sum + r[i]);
    });
  }

  void addRound(int winnerIndex, int points) {
    setState(() {
      List<int> round = List.filled(players.length, 0);
      round[winnerIndex] = points;
      rounds.add(round);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalsList = totals();
    final winnerIndex = totalsList.indexWhere(
            (t) => t >= widget.maxScore);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: widget.onReset,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (winnerIndex != -1)
              Text(
                '${players[winnerIndex]} wins! 🎉',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            buildTable(totalsList),
            const SizedBox(height: 20),
            AddPointsWidget(
              players: players,
              colors: colors,
              onAdd: addRound,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable(List<int> totalsList) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('TEAM',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          for (int i = 0; i < players.length; i++)
            Container(
              color: colors[i].withOpacity(0.2),
              padding: const EdgeInsets.all(8),
              child: Text(players[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
            ),
        ]),
        for (int r = 0; r < rounds.length; r++)
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Round ${r + 1}'),
            ),
            for (int i = 0; i < players.length; i++)
              Container(
                color: rounds[r][i] > 0
                    ? colors[i].withOpacity(0.3)
                    : null,
                padding: const EdgeInsets.all(8),
                child: Text(
                  rounds[r][i] == 0 ? '' : '${rounds[r][i]}',
                  textAlign: TextAlign.center,
                ),
              ),
          ]),
        TableRow(children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('TOTAL',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          for (int i = 0; i < players.length; i++)
            Container(
              color: colors[i].withOpacity(0.4),
              padding: const EdgeInsets.all(8),
              child: Text(
                '${totalsList[i]}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),
        ]),
      ],
    );
  }
}

/* ===================== ADD POINTS ===================== */

class AddPointsWidget extends StatefulWidget {
  final List<String> players;
  final List<Color> colors;
  final Function(int, int) onAdd;

  const AddPointsWidget({
    super.key,
    required this.players,
    required this.colors,
    required this.onAdd,
  });

  @override
  State<AddPointsWidget> createState() => _AddPointsWidgetState();
}

class _AddPointsWidgetState extends State<AddPointsWidget> {
  int selected = 0;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add Round Points'),
        Wrap(
          spacing: 8,
          children: List.generate(widget.players.length, (i) {
            return ChoiceChip(
              label: Text(widget.players[i]),
              selected: selected == i,
              selectedColor: widget.colors[i].withOpacity(0.5),
              onSelected: (_) => setState(() => selected = i),
            );
          }),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration:
          const InputDecoration(labelText: 'Points'),
        ),
        ElevatedButton(
          onPressed: () {
            final points = int.tryParse(controller.text) ?? 0;
            if (points > 0) {
              widget.onAdd(selected, points);
              controller.clear();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
