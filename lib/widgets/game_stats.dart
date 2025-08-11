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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Estatísticas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Icon(Icons.person, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    playerScore.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Text(
                'X',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const Icon(Icons.smart_toy, size: 36),
                  const SizedBox(height: 4),
                  Text(
                    aiScore.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconStat(
                context,
                icon: const Icon(Icons.touch_app_rounded),
                value: moves.toString(),
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 48),
              _iconStat(
                context,
                icon: const Icon(Icons.sports_esports),
                value: gamesPlayed.toString(),
                color: colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconStat(
    BuildContext context, {
    required Icon icon,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(
          icon.icon,
          size: 36,
          color: color,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
