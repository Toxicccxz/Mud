import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:martial_world/data/models/map_model.dart';

class MapPainter extends CustomPainter {
  final MapData currentMap; // 当前地图数据
  final List<MapData> allMaps; // 所有地图数据

  MapPainter({required this.currentMap, required this.allMaps});

  @override
  void paint(Canvas canvas, Size size) {
    var logger = Logger();
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);

    // 设置方块的大小
    const squareSize = 10.0;

    // 确认进入绘制
    logger.d('绘制当前地图: ${currentMap.name}');

    // 绘制中心地图 (实心方块)
    _drawSolidSquare(canvas, center, squareSize, paint);

    // 绘制其他地图（空心方块）和通路
    for (var map in allMaps) {
      if (map.id != currentMap.id) {
        // 计算其他地图的绘制位置
        Offset mapPosition =
            _getMapPositionRelativeToCenter(map, center, squareSize);
        _drawHollowSquare(canvas, mapPosition, squareSize, paint);
        canvas.drawLine(center, mapPosition, paint); // 绘制连接线
      }
    }
  }

  // 绘制实心方块
  void _drawSolidSquare(
      Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint);
  }

  // 绘制空心方块
  void _drawHollowSquare(
      Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint..style = PaintingStyle.stroke);
  }

  // 根据方向返回相对于中心的地图位置
  Offset _getMapPositionRelativeToCenter(
      MapData map, Offset center, double distance) {
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

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    // 重新绘制当当前地图或地图列表发生变化时
    return oldDelegate.currentMap != currentMap ||
        oldDelegate.allMaps != allMaps;
  }
}
