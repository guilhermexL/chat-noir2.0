import 'dart:math';
import '../models/position.dart';
import '../models/game_state.dart';
import '../models/move_result.dart';
import 'game_logic.dart';

class MinimaxAI {
  static const int maxDepth = 3;
  static const int infinity = 999999;

  static MoveResult getBestMove(GameState state) {
    final validMoves =
        GameLogic.getValidMoves(state, state.catPosition, isAI: true);

    if (validMoves.isEmpty) {
      return MoveResult(
        newPosition: state.catPosition,
        score: -infinity,
        depth: 0,
      );
    }

    Position bestMove = validMoves.first;
    int bestScore = -infinity;

    for (final move in validMoves) {
      final newState = GameLogic.moveCat(state, move);
      final score = minimax(newState, maxDepth - 1, -infinity, infinity, false);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return MoveResult(
      newPosition: bestMove,
      score: bestScore,
      depth: maxDepth,
    );
  }

  static int minimax(
      GameState state, int depth, int alpha, int beta, bool isMaximizing) {
    if (depth == 0 || state.status != GameStatus.playing) {
      return evaluate(state);
    }

    if (isMaximizing) {
      int maxEval = -infinity;
      final validMoves =
          GameLogic.getValidMoves(state, state.catPosition, isAI: true);

      for (final move in validMoves) {
        final newState = GameLogic.moveCat(state, move);
        final eval = minimax(newState, depth - 1, alpha, beta, false);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);

        if (beta <= alpha) break;
      }

      return maxEval;
    } else {
      int minEval = infinity;

      for (int row = 0; row < GameLogic.boardSize; row++) {
        for (int col = 0; col < GameLogic.boardSize; col++) {
          final pos = Position(row, col);
          if (state.isEmpty(pos)) {
            final newState = GameLogic.placeFence(state, pos);
            final eval = minimax(newState, depth - 1, alpha, beta, true);
            minEval = min(minEval, eval);
            beta = min(beta, eval);

            if (beta <= alpha) break;
          }
        }
        if (beta <= alpha) break;
      }

      return minEval;
    }
  }

  static int evaluate(GameState state) {
    if (state.status == GameStatus.aiWin) return 1000;
    if (state.status == GameStatus.playerWin) return -1000;

    final shortestPath =
        GameLogic.getShortestPathToEdge(state, state.catPosition);
    final validMoves =
        GameLogic.getValidMoves(state, state.catPosition, isAI: true).length;

    int pathScore = -shortestPath * 10;
    int mobilityScore = validMoves * 5;

    int edgeBonus = 0;
    if (state.isEdge(state.catPosition)) {
      edgeBonus = 100;
    } else {
      final distanceFromCenter =
          (state.catPosition.row - 5).abs() + (state.catPosition.col - 5).abs();
      edgeBonus = distanceFromCenter * 2;
    }

    return pathScore + mobilityScore + edgeBonus;
  }
}
