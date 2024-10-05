class NPC {
  final String id;
  final String name;
  final String role; // 功能性 NPC 的角色（如商人、任务提供者）

  NPC({
    required this.id,
    required this.name,
    required this.role,
  });

  factory NPC.fromJson(Map<String, dynamic> json) {
    return NPC(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }
}