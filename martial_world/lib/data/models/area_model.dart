import 'map_model.dart';

class Area {
  final String id;
  final String name;
  final List<MapData> maps; // 该区域中的多个地图

  Area({
    required this.id,
    required this.name,
    required this.maps,
  });

  // 从 JSON 解析
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      maps: (json['maps'] as List).map((map) => MapData.fromJson(map)).toList(),
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'maps': maps.map((map) => map.toJson()).toList(),
    };
  }
}
