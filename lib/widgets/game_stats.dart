import 'package:flutter/material.dart';

class GameStats extends StatelessWidget {
  final int playerScore;
  final int aiScore;
  final int moves;
  final int gamesPlayed;

  const GameStats({
    super.key,
    required this.playerScore,
    required this.aiScore,
    required this.moves,
    required this.gamesPlayed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Estatísticas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Jogador',
                  playerScore.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'IA',
                  aiScore.toString(),
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Movimentos',
                  moves.toString(),
                  Colors.orange,
                ),
                _buildStatItem(
                  context,
                  'Jogos',
                  gamesPlayed.toString(),
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
