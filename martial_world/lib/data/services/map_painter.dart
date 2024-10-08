import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:martial_world/data/models/map_model.dart';

import '../models/room_model.dart';

class MapPainter extends CustomPainter {
  final MapData currentMap; // 当前所在的地图
  final String? currentRoomId; // 当前所在的房间ID
  final List<MapData> allMaps; // 所有地图

  MapPainter({
    required this.currentMap,
    required this.allMaps,
    this.currentRoomId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var logger = Logger();
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);

    // 设置方块和圆圈的大小
    const squareSize = 10.0;
    const roomSize = 5.0;

    logger.d('绘制当前地图: ${currentMap.name}');

    // 绘制当前地图为实心方块
    _drawSolidSquare(canvas, center, squareSize, paint);

    // 绘制房间信息
    if (currentMap.rooms != null && currentMap.rooms!.isNotEmpty) {
      for (var room in currentMap.rooms!) {
        // 判断房间的绘制位置，默认相对中心位置绘制
        Offset roomPosition = _getRoomPositionRelativeToMap(room, center, roomSize);

        // 判断是否是当前房间
        if (room.id == currentRoomId) {
          // 当前房间显示为实心圆圈
          _drawSolidCircle(canvas, roomPosition, roomSize, paint);
        } else {
          // 其他房间显示为空心圆圈
          _drawHollowCircle(canvas, roomPosition, roomSize, paint);
        }
        
        // 绘制通向房间的线
        canvas.drawLine(center, roomPosition, paint);
      }
    }

    // 绘制其他地图（空心方块）和通路
    for (var map in allMaps) {
      if (map.id != currentMap.id) {
        // 计算其他地图的绘制位置（根据不同方向）
        Offset mapPosition = _getMapPositionRelativeToCenter(map, center, squareSize);

        // 绘制空心方块表示其他地图
        _drawHollowSquare(canvas, mapPosition, squareSize, paint);

        // 绘制通向其他地图的线
        canvas.drawLine(center, mapPosition, paint);
      }
    }
  }

  // 绘制实心方块
  void _drawSolidSquare(Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint);
  }

  // 绘制空心方块
  void _drawHollowSquare(Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint..style = PaintingStyle.stroke);
  }

  // 绘制实心圆圈（当前房间）
  void _drawSolidCircle(Canvas canvas, Offset position, double radius, Paint paint) {
    canvas.drawCircle(position, radius, paint);
  }

  // 绘制空心圆圈（其他房间）
  void _drawHollowCircle(Canvas canvas, Offset position, double radius, Paint paint) {
    canvas.drawCircle(position, radius, paint..style = PaintingStyle.stroke);
  }

  // 根据方向返回相对于中心的地图位置
  Offset _getMapPositionRelativeToCenter(MapData map, Offset center, double distance) {
    if (map.exits.contains('北')) {
      return Offset(center.dx, center.dy - distance * 2);
    } else if (map.exits.contains('南')) {
      return Offset(center.dx, center.dy + distance * 2);
    } else if (map.exits.contains('东')) {
      return Offset(center.dx + distance * 2, center.dy);
    } else if (map.exits.contains('西')) {
      return Offset(center.dx - distance * 2, center.dy);
    }
    return center;
  }

  // 返回相对于地图中心的位置绘制房间
  Offset _getRoomPositionRelativeToMap(Room room, Offset center, double distance) {
    if (room.exit == '北') {
      return Offset(center.dx, center.dy - distance * 1.5);
    } else if (room.exit == '南') {
      return Offset(center.dx, center.dy + distance * 1.5);
    } else if (room.exit == '东') {
      return Offset(center.dx + distance * 1.5, center.dy);
    } else if (room.exit == '西') {
      return Offset(center.dx - distance * 1.5, center.dy);
    }
    return center;
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    // 只有当地图或房间发生变化时，才重新绘制
    return oldDelegate.currentMap != currentMap || oldDelegate.currentRoomId != currentRoomId;
  }
}