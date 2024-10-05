import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:martial_world/data/models/map_model.dart';

class MapService {
  // 加载地图数据
  Future<MapData?> loadMap(String mapName) async {
    try {
      // 加载 JSON 文件中的地图数据
      final String response = await rootBundle.loadString('assets/maps/map_data.json');
      final List<dynamic> mapList = jsonDecode(response);
      
      // 查找对应的地图
      for (var mapJson in mapList) {
        MapData mapData = MapData.fromJson(mapJson);
        if (mapData.name == mapName) {
          return mapData;
        }
      }
    } catch (e) {
      print('加载地图数据失败: $e');
    }
    return null;
  }
}