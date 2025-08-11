import 'dart:math';
import '../models/position.dart';
import '../models/game_state.dart';

class GameLogic {
  static const int boardSize = 11;
  static const Position center = Position(5, 5);

  static List<Position> getHexNeighbors(int row) {
    if (row % 2 == 0) {
      // linha par
      return [
        Position(-1, 0), // N
        Position(-1, 1), // NE
        Position(0, 1), // SE
        Position(1, 0), // S
        Position(0, -1), // SW
        Position(-1, -1), // NW
      ];
    } else {
      // linha ímpar
      return [
        Position(-1, 0), // N
        Position(-1, 0), // NE
        Position(0, 1), // SE
        Position(1, 0), // S
        Position(0, -1), // SW
        Position(-1, -1), // NW
      ];
    }
  }

  static GameState createInitialState() {
    final board = List.generate(
      boardSize,
      (i) => List.generate(boardSize, (j) => CellType.empty),
    );

    board[center.row][center.col] = CellType.cat;

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

  static List<Position> getValidMoves(GameState state, Position from,
      {bool isAI = false}) {
    final validMoves = <Position>[];
    final directions = getHexNeighbors(from.row);

    for (int i = 0; i < directions.length; i++) {
      if (isAI) {
        if (from.row % 2 == 0) {
          if (i == 1 || i == 2) continue;
        } else {
          if (i == 4 || i == 5) continue;
        }
      }

      final newPos =
          Position(from.row + directions[i].row, from.col + directions[i].col);
      if (state.isValidPosition(newPos) && state.isEmpty(newPos)) {
        validMoves.add(newPos);
      }
    }

    return validMoves;
  }

  static bool isCatTrapped(GameState state) {
    return getValidMoves(state, state.catPosition, isAI: true).isEmpty;
  }

  static GameState placeFence(GameState state, Position position) {
    if (!state.isEmpty(position) || state.status != GameStatus.playing) {
      return state;
    }

    final newBoard =
        state.board.map((row) => List<CellType>.from(row)).toList();
    newBoard[position.row][position.col] = CellType.fence;

    final newState = state.copyWith(
      board: newBoard,
      moves: state.moves + 1,
    );

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

    final newBoard =
        state.board.map((row) => List<CellType>.from(row)).toList();
    newBoard[state.catPosition.row][state.catPosition.col] = CellType.empty;
    newBoard[newPosition.row][newPosition.col] = CellType.cat;

    GameStatus newStatus = state.status;
    int newAiScore = state.aiScore;

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

      final directions = getHexNeighbors(pos.row);

      for (final direction in directions) {
        final newPos =
            Position(pos.row + direction.row, pos.col + direction.col);
        if (state.isValidPosition(newPos) &&
            state.isEmpty(newPos) &&
            !visited.contains(newPos)) {
          visited.add(newPos);
          queue.add(MapEntry(newPos, distance + 1));
        }
      }
    }

    return 1000;
  }
}
