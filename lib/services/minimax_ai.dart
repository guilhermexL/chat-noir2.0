import 'dart:math';
import '../models/position.dart';
import '../models/game_state.dart';
import '../models/move_result.dart';
import 'game_logic.dart';

class MinimaxAI {
  static const int maxDepth = 3;
  static const int infinity = 999999;

  static MoveResult getBestMove(GameState state) {
    final validMoves = GameLogic.getValidMoves(state, state.catPosition);
    
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

  static int minimax(GameState state, int depth, int alpha, int beta, bool isMaximizing) {
    // Condições de parada
    if (depth == 0 || state.status != GameStatus.playing) {
      return evaluate(state);
    }

    if (isMaximizing) {
      // Turno da IA (gato)
      int maxEval = -infinity;
      final validMoves = GameLogic.getValidMoves(state, state.catPosition);
      
      for (final move in validMoves) {
        final newState = GameLogic.moveCat(state, move);
        final eval = minimax(newState, depth - 1, alpha, beta, false);
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        
        if (beta <= alpha) {
          break; // Poda alfa-beta
        }
      }
      
      return maxEval;
    } else {
      // Turno do jogador (colocar cerca)
      int minEval = infinity;
      
      // Simula possíveis jogadas do jogador
      for (int row = 0; row < GameLogic.boardSize; row++) {
        for (int col = 0; col < GameLogic.boardSize; col++) {
          final pos = Position(row, col);
          if (state.isEmpty(pos)) {
            final newState = GameLogic.placeFence(state, pos);
            final eval = minimax(newState, depth - 1, alpha, beta, true);
            minEval = min(minEval, eval);
            beta = min(beta, eval);
            
            if (beta <= alpha) {
              break; // Poda alfa-beta
            }
          }
        }
        if (beta <= alpha) break;
      }
      
      return minEval;
    }
  }

  static int evaluate(GameState state) {
    // Se o jogo terminou
    if (state.status == GameStatus.aiWin) {
      return 1000;
    }
    if (state.status == GameStatus.playerWin) {
      return -1000;
    }

    // Heurística baseada em:
    // 1. Distância até a borda mais próxima
    // 2. Número de movimentos válidos disponíveis
    // 3. Posição estratégica no tabuleiro

    final shortestPath = GameLogic.getShortestPathToEdge(state, state.catPosition);
    final validMoves = GameLogic.getValidMoves(state, state.catPosition).length;
    
    // Quanto menor a distância para a borda, melhor para a IA
    int pathScore = -shortestPath * 10;
    
    // Quanto mais opções de movimento, melhor para a IA
    int mobilityScore = validMoves * 5;
    
    // Bonus por estar próximo das bordas
    int edgeBonus = 0;
    if (state.isEdge(state.catPosition)) {
      edgeBonus = 100;
    } else {
      final distanceFromCenter = (state.catPosition.row - 5).abs() + 
                                (state.catPosition.col - 5).abs();
      edgeBonus = distanceFromCenter * 2;
    }

    return pathScore + mobilityScore + edgeBonus;
  }
}
