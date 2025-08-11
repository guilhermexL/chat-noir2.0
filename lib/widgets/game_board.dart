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
    final rows = gameState.board.length;
    final cols = gameState.board.isNotEmpty ? gameState.board[0].length : 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final maxH = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height * 0.8;

        final cellSizeByHeight = maxH / rows;
        final cellSizeByWidth = maxW / (cols + 0.5);
        final cellSize = cellSizeByHeight < cellSizeByWidth
            ? cellSizeByHeight
            : cellSizeByWidth;

        final boardWidth = cellSize * (cols + 0.5);
        final boardHeight = cellSize * rows;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: boardWidth,
            height: boardHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(rows, (row) {
                final isOddRow = row.isOdd;
                return SizedBox(
                  height: cellSize,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isOddRow) SizedBox(width: cellSize / 2),
                      ...List.generate(cols, (col) {
                        final position = Position(row, col);
                        final cellType = gameState.board[row][col];
                        final isSelected = selectedPosition == position;

                        return SizedBox(
                          width: cellSize,
                          height: cellSize,
                          child: HexCell(
                            position: position,
                            cellType: cellType,
                            isSelected: isSelected,
                            onTap: () => onCellTap(position),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
