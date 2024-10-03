class SaveData {
  final String playerName;
  final int playerLevel;
  final int experiencePoints;
  final String currentMap;
  final Map<String, dynamic> gameState;

  SaveData({
    required this.playerName,
    required this.playerLevel,
    required this.experiencePoints,
    required this.currentMap,
    required this.gameState,
  });

  // 将存档转换为 JSON 格式，便于存储
  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'playerLevel': playerLevel,
      'experiencePoints': experiencePoints,
      'currentMap': currentMap,
      'gameState': gameState,
    };
  }

  // 从 JSON 数据恢复存档
  factory SaveData.fromJson(Map<String, dynamic> json) {
    return SaveData(
      playerName: json['playerName'],
      playerLevel: json['playerLevel'],
      experiencePoints: json['experiencePoints'],
      currentMap: json['currentMap'],
      gameState: Map<String, dynamic>.from(json['gameState']),
    );
  }
}