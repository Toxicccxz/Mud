import 'package:flutter/foundation.dart';
import 'package:martial_world/data/models/map_model.dart';

class GameState extends ChangeNotifier {
  MapData _currentMap; // 当前地图
  String? _currentRoomId; // 当前房间的ID
  final List<MapData> allMaps; // 所有地图

  GameState({
    required MapData initialMap, 
    required this.allMaps,
    String? initialRoomId,
  })  : _currentMap = initialMap,
        _currentRoomId = initialRoomId;

  MapData get currentMap => _currentMap;

  // 当前房间ID
  String? get currentRoomId => _currentRoomId;

  // 更新地图并通知监听者
  void moveToNextMap(MapData newMap) {
    _currentMap = newMap;
    _currentRoomId = null; // 移动到新地图时重置房间
    notifyListeners(); // 通知所有监听者更新
  }

  // 更新当前房间并通知监听者
  void moveToNextRoom(String roomId) {
    _currentRoomId = roomId;
    notifyListeners(); // 通知监听者房间更新
  }
}