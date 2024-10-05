class Enemy {
  final String id;
  final String name;
  final int level; // 敌人的等级
  final int health; // 敌人的生命值

  Enemy({
    required this.id,
    required this.name,
    required this.level,
    required this.health,
  });

  factory Enemy.fromJson(Map<String, dynamic> json) {
    return Enemy(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      health: json['health'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'health': health,
    };
  }
}