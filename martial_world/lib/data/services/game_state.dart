import 'package:flutter/foundation.dart';
import 'package:martial_world/data/models/map_model.dart';

class GameState extends ChangeNotifier {
  MapData _currentMap;
  List<MapData> allMaps;

  GameState({required MapData initialMap, required this.allMaps}) : _currentMap = initialMap;

  // 获取当前地图
  MapData get currentMap => _currentMap;

  // 更新地图
  void moveToNextMap(MapData newMap) {
    _currentMap = newMap;
    notifyListeners(); // 通知 UI 更新
  }
}