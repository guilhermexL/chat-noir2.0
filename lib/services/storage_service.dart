import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _playerScoreKey = 'player_score';
  static const String _aiScoreKey = 'ai_score';
  static const String _gamesPlayedKey = 'games_played';

  static Future<void> saveScore(int playerScore, int aiScore) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_playerScoreKey, playerScore);
    await prefs.setInt(_aiScoreKey, aiScore);
    
    final gamesPlayed = await getGamesPlayed();
    await prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);
  }

  static Future<int> getPlayerScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_playerScoreKey) ?? 0;
  }

  static Future<int> getAiScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_aiScoreKey) ?? 0;
  }

  static Future<int> getGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_gamesPlayedKey) ?? 0;
  }

  static Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playerScoreKey);
    await prefs.remove(_aiScoreKey);
    await prefs.remove(_gamesPlayedKey);
  }
}
