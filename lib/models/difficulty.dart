enum Difficulty {
  easy(depth: 2, name: 'Fácil'),
  medium(depth: 3, name: 'Médio'),
  hard(depth: 4, name: 'Difícil');

  const Difficulty({
    required this.depth,
    required this.name,
  });

  final int depth;
  final String name;
}
