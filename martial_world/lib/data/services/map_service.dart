import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:martial_world/data/models/map_model.dart';
import 'package:martial_world/data/models/area_model.dart'; // 导入区域模型

class MapService {
  var logger = Logger();
  // 加载地图数据
  Future<MapData?> loadMap(String mapName) async {
    try {
      // 加载 JSON 文件中的区域数据
      final String response = await rootBundle.loadString('assets/maps/map_data.json');
      final List<dynamic> areaList = jsonDecode(response);
      
      // 遍历所有区域
      for (var areaJson in areaList) {
        Area areaData = Area.fromJson(areaJson);
        // 遍历每个区域中的地图
        for (var map in areaData.maps) {
          // 打印地图名称
          logger.i('加载地图数据: ${map.name}');
          if (map.name == mapName) {
            return map;
          }
        }
      }
    } catch (e) {
      logger.e('加载地图数据失败: $e');
    }
    return null;
  }

  // 新增: 加载所有地图
  Future<List<MapData>> loadAllMaps() async {
    try {
      final String response = await rootBundle.loadString('assets/maps/map_data.json');
      final List<dynamic> areaList = jsonDecode(response);
      List<MapData> allMaps = [];
      
      // 遍历所有区域并获取其中的所有地图
      for (var areaJson in areaList) {
        Area areaData = Area.fromJson(areaJson);
        allMaps.addAll(areaData.maps); // 添加所有地图
      }
      
      return allMaps;
    } catch (e) {
      logger.e('加载所有地图数据失败: $e');
      return [];
    }
  }
}
