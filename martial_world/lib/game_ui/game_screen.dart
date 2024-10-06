import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:martial_world/data/models/save_data.dart';
import 'package:martial_world/data/models/map_model.dart'; // 导入地图模型
import '../data/services/map_painter.dart'; // 导入自定义的 MapPainter

class GameScreen extends StatefulWidget {
  final SaveData saveData;
  final MapData currentMapData; // 当前地图的数据
  final List<MapData> allMaps; // 所有地图数据

  const GameScreen({
    super.key,
    required this.saveData,
    required this.currentMapData,
    required this.allMaps,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MapData _currentMapData; // 当前地图的数据

  @override
  void initState() {
    super.initState();
    _currentMapData = widget.currentMapData; // 初始化当前地图为传入的地图
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('游戏 - ${widget.saveData.playerName}'),
      ),
      body: Column(
        children: [
          // 顶部玩家信息区域
          _buildPlayerInfo(),
          // 地图区域，使用 CustomPaint 来绘制地图
          Container(
            height: 200,
            child: RepaintBoundary(
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: MapPainter(
                  currentMap: _currentMapData,
                  allMaps: widget.allMaps,
                ),
              ),
            ),
          ),
          // 中间环境描述区域
          Expanded(
            child: _buildEnvironmentDescription(),
          ),
          // 底部指令输入与动作按钮
          _buildActionsAndInput(),
        ],
      ),
    );
  }

  // 构建玩家信息区域
  Widget _buildPlayerInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('玩家: ${widget.saveData.playerName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('等级: ${widget.saveData.playerLevel}',
              style: TextStyle(fontSize: 16)),
          Text('经验值: ${widget.saveData.experiencePoints}',
              style: TextStyle(fontSize: 16)),
          Text('当前位置: ${_currentMapData.name}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 构建环境描述区域，使用 `_currentMapData` 的信息
  Widget _buildEnvironmentDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Text(
            _generateEnvironmentDescription(), // 动态生成环境描述
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // 生成环境描述，根据当前地图的 NPC、敌人、道具等内容
  String _generateEnvironmentDescription() {
    String description = '你现在位于 ${_currentMapData.name}。\n';

    if (_currentMapData.npcs != null && _currentMapData.npcs!.isNotEmpty) {
      description += '这里有一些NPC: \n';
      for (var npc in _currentMapData.npcs!) {
        description += '- ${npc.name} (${npc.role})\n';
      }
    }

    if (_currentMapData.enemies != null &&
        _currentMapData.enemies!.isNotEmpty) {
      description += '危险! 周围有敌人: \n';
      for (var enemy in _currentMapData.enemies!) {
        description += '- ${enemy.name}, 等级 ${enemy.level}\n';
      }
    }

    if (_currentMapData.items != null && _currentMapData.items!.isNotEmpty) {
      description += '这里有一些可以拾取的道具: \n';
      for (var item in _currentMapData.items!) {
        description += '- ${item.name}: ${item.description}\n';
      }
    }

    return description;
  }

  // 构建动作按钮和指令区域
  Widget _buildActionsAndInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 动作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildExitButtons(),
          ),
        ],
      ),
    );
  }

  // 根据地图的出入口构建按钮，并更新当前地图数据
  List<Widget> _buildExitButtons() {
    List<Widget> buttons = [];

    if (_currentMapData.exits.contains('北')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap('北'),
        child: const Text('向北'),
      ));
    }

    if (_currentMapData.exits.contains('南')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap('南'),
        child: const Text('向南'),
      ));
    }

    if (_currentMapData.exits.contains('东')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap('东'),
        child: const Text('向东'),
      ));
    }

    if (_currentMapData.exits.contains('西')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap('西'),
        child: const Text('向西'),
      ));
    }

    return buttons;
  }

// 移动到下一个地图
  void _moveToNextMap(String direction) {
    var logger = Logger();

    // 查找与当前地图相连的下一个地图
    for (var map in widget.allMaps) {
      if (map.exits.contains(direction) && map.name != _currentMapData.name) {
        setState(() {
          _currentMapData = map; // 更新当前地图
        });
        logger.d('移动到 ${map.name}');
        break;
      }
    }
  }
}
