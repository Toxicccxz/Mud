import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:martial_world/data/models/map_model.dart';

class MapService {
  var logger = Logger();
  // 加载当前地图数据
  Future<MapData?> loadMap(String mapName) async {
    try {
      final String response = await rootBundle.loadString('assets/maps/map_data.json');
      final List<dynamic> mapList = jsonDecode(response);
      
      for (var mapJson in mapList) {
        MapData mapData = MapData.fromJson(mapJson);
        if (mapData.name == mapName) {
          return mapData;
        }
      }
    } catch (e) {
      logger.e('加载地图数据失败: $e');
    }
    return null;
  }

  // 新增：加载所有地图数据
  Future<List<MapData>> loadAllMaps() async {
    try {
      final String response = await rootBundle.loadString('assets/maps/map_data.json');
      final List<dynamic> mapList = jsonDecode(response);
      return mapList.map((mapJson) => MapData.fromJson(mapJson)).toList();
    } catch (e) {
      logger.e('加载所有地图数据失败: $e');
      return [];
    }
  }
}