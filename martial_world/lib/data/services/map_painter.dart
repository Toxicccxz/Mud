import 'package:flutter/material.dart';
import 'package:martial_world/data/models/map_model.dart';

class MapPainter extends CustomPainter {
  final MapData currentMap; // 当前地图数据
  final List<MapData> allMaps; // 所有地图数据
  
  MapPainter({required this.currentMap, required this.allMaps});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    
    // 设置方块的大小
    const squareSize = 10.0;

    // 绘制中心地图 (实心方块)
    _drawSolidSquare(canvas, center, squareSize, paint);

    // 绘制其他地图（空心方块）和通路
    for (var map in allMaps) {
      if (map.id != currentMap.id) {
        // 计算其他地图的绘制位置（比如简单的在中心地图的上下左右）
        Offset mapPosition = _getMapPositionRelativeToCenter(map, center, squareSize);

        // 绘制空心方块
        _drawHollowSquare(canvas, mapPosition, squareSize, paint);

        // 绘制连接线
        canvas.drawLine(center, mapPosition, paint);
      }
    }
  }

  // 绘制实心方块
  void _drawSolidSquare(Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint); // 实心方块
  }

  // 绘制空心方块
  void _drawHollowSquare(Canvas canvas, Offset position, double size, Paint paint) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawRect(rect, paint..style = PaintingStyle.stroke); // 空心方块
  }

  // 根据方向返回相对于中心的地图位置 (这里只是一个简单的逻辑)
  Offset _getMapPositionRelativeToCenter(MapData map, Offset center, double distance) {
    if (map.exits.contains('北')) {
      return Offset(center.dx, center.dy - distance * 2); // 上方
    } else if (map.exits.contains('南')) {
      return Offset(center.dx, center.dy + distance * 2); // 下方
    } else if (map.exits.contains('东')) {
      return Offset(center.dx + distance * 2, center.dy); // 右侧
    } else if (map.exits.contains('西')) {
      return Offset(center.dx - distance * 2, center.dy); // 左侧
    }
    return center; // 默认返回中心位置
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
