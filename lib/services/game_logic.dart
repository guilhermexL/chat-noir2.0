import 'dart:math';
import '../models/position.dart';
import '../models/game_state.dart';

class GameLogic {
  static const int boardSize = 11;
  static const Position center = Position(5, 5);
  
  // Direções hexagonais simuladas
  static const List<Position> hexDirections = [
    Position(-1, 0),  // Norte
    Position(-1, 1),  // Nordeste
    Position(0, 1),   // Sudeste
    Position(1, 0),   // Sul
    Position(1, -1),  // Sudoeste
    Position(0, -1),  // Noroeste
  ];

  static GameState createInitialState() {
    final board = List.generate(
      boardSize,
      (i) => List.generate(boardSize, (j) => CellType.empty),
    );

    // Coloca o gato no centro
    board[center.row][center.col] = CellType.cat;

    // Coloca 12 cercas aleatoriamente
    final random = Random();
    int fencesPlaced = 0;
    
    while (fencesPlaced < 12) {
      final row = random.nextInt(boardSize);
      final col = random.nextInt(boardSize);
      final pos = Position(row, col);
      
      if (board[row][col] == CellType.empty && pos != center) {
        board[row][col] = CellType.fence;
        fencesPlaced++;
      }
    }

    return GameState(
      board: board,
      catPosition: center,
      status: GameStatus.playing,
      playerScore: 0,
      aiScore: 0,
      moves: 0,
    );
  }

  static List<Position> getValidMoves(GameState state, Position from) {
    final validMoves = <Position>[];
    
    for (final direction in hexDirections) {
      final newPos = from + direction;
      if (state.isValidPosition(newPos) && state.isEmpty(newPos)) {
        validMoves.add(newPos);
      }
    }
    
    return validMoves;
  }

  static bool isCatTrapped(GameState state) {
    return getValidMoves(state, state.catPosition).isEmpty;
  }

  static GameState placeFence(GameState state, Position position) {
    if (!state.isEmpty(position) || state.status != GameStatus.playing) {
      return state;
    }

    final newBoard = state.board.map((row) => List<CellType>.from(row)).toList();
    newBoard[position.row][position.col] = CellType.fence;

    final newState = state.copyWith(
      board: newBoard,
      moves: state.moves + 1,
    );

    // Verifica se o gato está preso
    if (isCatTrapped(newState)) {
      return newState.copyWith(
        status: GameStatus.playerWin,
        playerScore: state.playerScore + 1,
      );
    }

    return newState;
  }

  static GameState moveCat(GameState state, Position newPosition) {
    if (state.status != GameStatus.playing || !state.isEmpty(newPosition)) {
      return state;
    }

    final newBoard = state.board.map((row) => List<CellType>.from(row)).toList();
    newBoard[state.catPosition.row][state.catPosition.col] = CellType.empty;
    newBoard[newPosition.row][newPosition.col] = CellType.cat;

    GameStatus newStatus = state.status;
    int newAiScore = state.aiScore;

    // Verifica se o gato escapou
    if (state.isEdge(newPosition)) {
      newStatus = GameStatus.aiWin;
      newAiScore = state.aiScore + 1;
    }

    return state.copyWith(
      board: newBoard,
      catPosition: newPosition,
      status: newStatus,
      aiScore: newAiScore,
    );
  }

  static int getShortestPathToEdge(GameState state, Position from) {
    final visited = <Position>{};
    final queue = <MapEntry<Position, int>>[];
    
    queue.add(MapEntry(from, 0));
    visited.add(from);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final pos = current.key;
      final distance = current.value;

      if (state.isEdge(pos)) {
        return distance;
      }

      for (final direction in hexDirections) {
        final newPos = pos + direction;
        if (state.isValidPosition(newPos) && 
            state.isEmpty(newPos) && 
            !visited.contains(newPos)) {
          visited.add(newPos);
          queue.add(MapEntry(newPos, distance + 1));
        }
      }
    }

    return 1000; // Sem caminho disponível
  }
}
