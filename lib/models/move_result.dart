import 'position.dart';

class MoveResult {
  final Position newPosition;
  final int score;
  final int depth;

  MoveResult({
    required this.newPosition,
    required this.score,
    required this.depth,
  });
}
