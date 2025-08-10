import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/position.dart';
import '../models/game_state.dart';
import '../services/game_logic.dart';
import '../services/minimax_ai.dart';
import '../services/storage_service.dart';
import '../widgets/game_board.dart';
import '../widgets/game_stats.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const GameScreen({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _gameState;
  Position? _selectedPosition;
  bool _isLoading = true;
  bool _isAiThinking = false;
  int _totalGamesPlayed = 0;

  late AnimationController _catAnimationController;
  late Animation<Offset> _catSlideAnimation;

  @override
  void initState() {
    super.initState();

    _gameState = GameLogic.createInitialState();

    _loadStatsAndInitializeGame();

    _catAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _catSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _catAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadStatsAndInitializeGame() async {
    final playerScore = await StorageService.getPlayerScore();
    final aiScore = await StorageService.getAiScore();
    final gamesPlayed = await StorageService.getGamesPlayed();

    setState(() {
      _totalGamesPlayed = gamesPlayed;
      _initializeGame(playerScore: playerScore, aiScore: aiScore);
      _isLoading = false;
    });
  }

  void _initializeGame({int playerScore = 0, int aiScore = 0}) {
    _gameState = GameLogic.createInitialState().copyWith(
      playerScore: playerScore,
      aiScore: aiScore,
    );
    _selectedPosition = null;
    _isAiThinking = false;
  }

  Future<void> _saveStats() async {
    await StorageService.saveScore(_gameState.playerScore, _gameState.aiScore);
    await _loadStats();
  }

  Future<void> _loadStats() async {
    final gamesPlayed = await StorageService.getGamesPlayed();
    setState(() {
      _totalGamesPlayed = gamesPlayed;
    });
  }

  void _newGame() async {
    HapticFeedback.mediumImpact();

    final playerScore = await StorageService.getPlayerScore();
    final aiScore = await StorageService.getAiScore();

    setState(() {
      _initializeGame(playerScore: playerScore, aiScore: aiScore);
    });
  }

  Future<void> _resetStats() async {
    await StorageService.resetStats();
    await _loadStats();
    setState(() {
      _gameState = _gameState.copyWith(
        playerScore: 0,
        aiScore: 0,
      );
    });
  }

  @override
  void dispose() {
    _catAnimationController.dispose();
    super.dispose();
  }

  void _onCellTap(Position position) {
    if (_isAiThinking || _gameState.status != GameStatus.playing) {
      return;
    }

    // Só permite colocar cerca em células vazias
    if (!_gameState.isEmpty(position)) {
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _selectedPosition = position;
      _gameState = GameLogic.placeFence(_gameState, position);
    });

    // Se o jogo não terminou, é a vez da IA
    if (_gameState.status == GameStatus.playing) {
      _makeAiMove();
    } else {
      _saveStats();
    }
  }

  Future<void> _makeAiMove() async {
    setState(() {
      _isAiThinking = true;
    });

    // Adiciona um pequeno delay para mostrar que a IA está "pensando"
    await Future.delayed(const Duration(milliseconds: 800));

    final aiMove = MinimaxAI.getBestMove(_gameState);

    // Anima o movimento do gato
    await _animateCatMovement(_gameState.catPosition, aiMove.newPosition);

    setState(() {
      _gameState = GameLogic.moveCat(_gameState, aiMove.newPosition);
      _isAiThinking = false;
      _selectedPosition = null;
    });

    if (_gameState.status != GameStatus.playing) {
      HapticFeedback.mediumImpact();
      _saveStats();
    }
  }

  Future<void> _animateCatMovement(Position from, Position to) async {
    final dx = (to.col - from.col).toDouble();
    final dy = (to.row - from.row).toDouble();

    _catSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx * 0.1, dy * 0.1),
    ).animate(CurvedAnimation(
      parent: _catAnimationController,
      curve: Curves.easeInOut,
    ));

    await _catAnimationController.forward();
    await _catAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Noir'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isAiThinking)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GameStats(
                playerScore: _gameState.playerScore,
                aiScore: _gameState.aiScore,
                moves: _gameState.moves,
                gamesPlayed: _totalGamesPlayed,
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _catSlideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _catSlideAnimation.value,
                    child: GameBoard(
                      gameState: _gameState,
                      onCellTap: _onCellTap,
                      selectedPosition: _selectedPosition,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              GameControls(
                gameStatus: _gameState.status,
                onNewGame: _newGame,
                onThemeToggle: widget.onThemeToggle,
                onResetStats: _resetStats,
              ),
              if (_isAiThinking)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('IA pensando...'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
