import 'position.dart';

enum CellType { empty, fence, cat }
enum GameStatus { playing, playerWin, aiWin }

class GameState {
  final List<List<CellType>> board;
  final Position catPosition;
  final GameStatus status;
  final int playerScore;
  final int aiScore;
  final int moves;

  GameState({
    required this.board,
    required this.catPosition,
    required this.status,
    required this.playerScore,
    required this.aiScore,
    required this.moves,
  });

  GameState copyWith({
    List<List<CellType>>? board,
    Position? catPosition,
    GameStatus? status,
    int? playerScore,
    int? aiScore,
    int? moves,
  }) {
    return GameState(
      board: board ?? this.board.map((row) => List<CellType>.from(row)).toList(),
      catPosition: catPosition ?? this.catPosition,
      status: status ?? this.status,
      playerScore: playerScore ?? this.playerScore,
      aiScore: aiScore ?? this.aiScore,
      moves: moves ?? this.moves,
    );
  }

  bool isValidPosition(Position pos) {
    return pos.row >= 0 && pos.row < 11 && pos.col >= 0 && pos.col < 11;
  }

  bool isEmpty(Position pos) {
    return isValidPosition(pos) && board[pos.row][pos.col] == CellType.empty;
  }

  bool isEdge(Position pos) {
    return pos.row == 0 || pos.row == 10 || pos.col == 0 || pos.col == 10;
  }
}
