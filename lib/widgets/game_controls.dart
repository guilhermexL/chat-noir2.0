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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outline, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (gameStatus != GameStatus.playing)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(context, gameStatus).withOpacity(0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatusIcon(gameStatus),
                      color: _getStatusColor(context, gameStatus),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(gameStatus),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _getStatusColor(context, gameStatus),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: IconButton(
                    onPressed: onNewGame,
                    icon: Icon(Icons.refresh, color: colorScheme.primary),
                    tooltip: 'Novo Jogo',
                    splashRadius: 24,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: IconButton(
                    onPressed: onThemeToggle,
                    icon: Icon(Icons.brightness_6, color: colorScheme.primary),
                    tooltip: 'Alternar Tema',
                    splashRadius: 24,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: IconButton(
                    onPressed: onResetStats,
                    icon: Icon(Icons.delete_forever,
                        color: colorScheme.secondary),
                    tooltip: 'Resetar Estatísticas',
                    splashRadius: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, GameStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case GameStatus.playerWin:
        return Colors.green[600]!;
      case GameStatus.aiWin:
        return colorScheme.error;
      case GameStatus.playing:
        return colorScheme.primary;
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
