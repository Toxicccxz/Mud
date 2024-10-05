class Room {
  final String id;
  final String description; // 房间的描述
  final String exit; // 房间唯一的出入口方向

  Room({
    required this.id,
    required this.description,
    required this.exit,
  });

  // 从 JSON 解析
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      description: json['description'],
      exit: json['exit'],
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'exit': exit,
    };
  }
}