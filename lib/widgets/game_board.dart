import 'package:flutter/material.dart';
import '../models/position.dart';
import '../models/game_state.dart';
import 'hex_cell.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final Function(Position) onCellTap;
  final Position? selectedPosition;

  const GameBoard({
    super.key,
    required this.gameState,
    required this.onCellTap,
    this.selectedPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 11,
              childAspectRatio: 1,
            ),
            itemCount: 121, // 11x11
            itemBuilder: (context, index) {
              final row = index ~/ 11;
              final col = index % 11;
              final position = Position(row, col);
              final cellType = gameState.board[row][col];
              final isSelected = selectedPosition == position;

              return HexCell(
                position: position,
                cellType: cellType,
                isSelected: isSelected,
                onTap: () => onCellTap(position),
              );
            },
          ),
        ),
      ),
    );
  }
}
