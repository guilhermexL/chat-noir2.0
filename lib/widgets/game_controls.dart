import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameControls extends StatelessWidget {
  final GameStatus gameStatus;
  final VoidCallback onNewGame;
  final VoidCallback onThemeToggle;
  final VoidCallback onResetStats;

  const GameControls({
    super.key,
    required this.gameStatus,
    required this.onNewGame,
    required this.onThemeToggle,
    required this.onResetStats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (gameStatus != GameStatus.playing)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(gameStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatusIcon(gameStatus),
                      color: _getStatusColor(gameStatus),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(gameStatus),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getStatusColor(gameStatus),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onNewGame,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Novo Jogo'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onThemeToggle,
                  icon: const Icon(Icons.brightness_6),
                  tooltip: 'Alternar Tema',
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onResetStats,
              child: const Text('Resetar Estatísticas'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.playerWin:
        return Colors.green;
      case GameStatus.aiWin:
        return Colors.red;
      case GameStatus.playing:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(GameStatus status) {
    switch (status) {
      case GameStatus.playerWin:
        return Icons.celebration;
      case GameStatus.aiWin:
        return Icons.sentiment_dissatisfied;
      case GameStatus.playing:
        return Icons.play_arrow;
    }
  }

  String _getStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.playerWin:
        return 'Você Venceu!';
      case GameStatus.aiWin:
        return 'IA Venceu!';
      case GameStatus.playing:
        return 'Jogando...';
    }
  }
}
