import 'room_model.dart';
import 'npc_model.dart';
import 'enemy_model.dart';
import 'item_model.dart';

class MapData {
  final String id;
  final String name;
  final String type; // 城镇或野外
  final List<String> exits; // 出入口方向（如：北、南、西）
  final List<Room>? rooms; // 地图中的房间（可以为空）
  final List<NPC>? npcs; // NPC 列表
  final List<Enemy>? enemies; // 野外敌人列表（城镇地图可能为空）
  final List<Item>? items; // 地图中的可拾取道具

  MapData({
    required this.id,
    required this.name,
    required this.type,
    required this.exits,
    this.rooms,
    this.npcs,
    this.enemies,
    this.items,
  });

  // 从 JSON 解析
  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      exits: List<String>.from(json['exits']),
      rooms: json['rooms'] != null
          ? (json['rooms'] as List).map((room) => Room.fromJson(room)).toList()
          : null,
      npcs: json['npcs'] != null
          ? (json['npcs'] as List).map((npc) => NPC.fromJson(npc)).toList()
          : null,
      enemies: json['enemies'] != null
          ? (json['enemies'] as List).map((enemy) => Enemy.fromJson(enemy)).toList()
          : null,
      items: json['items'] != null
          ? (json['items'] as List).map((item) => Item.fromJson(item)).toList()
          : null,
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'exits': exits,
      'rooms': rooms?.map((room) => room.toJson()).toList(),
      'npcs': npcs?.map((npc) => npc.toJson()).toList(),
      'enemies': enemies?.map((enemy) => enemy.toJson()).toList(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}