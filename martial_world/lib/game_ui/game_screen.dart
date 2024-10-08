import 'package:flutter/material.dart';
import 'package:martial_world/data/models/save_data.dart';
import 'package:martial_world/data/services/map_painter.dart';
import 'package:martial_world/data/services/game_state.dart'; // 导入游戏状态
import 'package:provider/provider.dart';
import '../data/models/map_model.dart';

class GameScreen extends StatelessWidget {
  final SaveData saveData;
  final MapData currentMapData;
  final List<MapData> allMaps;

  const GameScreen({
    super.key,
    required this.saveData,
    required this.currentMapData,
    required this.allMaps,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(initialMap: currentMapData, allMaps: allMaps),
      child: Scaffold(
        appBar: AppBar(
          title: Text('游戏 - ${saveData.playerName}'),
        ),
        body: Column(
          children: [
            // 顶部玩家信息区域
            _buildPlayerInfo(context),
            // 地图区域，使用 CustomPaint 来绘制地图
            Consumer<GameState>(
              builder: (context, gameState, _) {
                return SizedBox(
                  height: 200,
                  child: CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: MapPainter(
                      currentMap: gameState.currentMap,
                      allMaps: gameState.allMaps,
                      currentRoomId: gameState.currentRoomId, // 当前所在的房间ID
                    ),
                  ),
                );
              },
            ),
            // 中间环境描述区域
            Expanded(
              child: _buildEnvironmentDescription(context),
            ),
            // 底部指令输入与动作按钮
            _buildActionsAndInput(context),
          ],
        ),
      ),
    );
  }

  // 构建玩家信息区域
  Widget _buildPlayerInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('玩家: ${saveData.playerName}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('等级: ${saveData.playerLevel}',
              style: const TextStyle(fontSize: 16)),
          Text('经验值: ${saveData.experiencePoints}',
              style: const TextStyle(fontSize: 16)),
          Consumer<GameState>(
            builder: (context, gameState, _) {
              return Column(
                children: [
                  Text('当前位置: ${gameState.currentMap.name}',
                      style: const TextStyle(fontSize: 16)),
                  if (gameState.currentRoomId != null)
                    Text('当前房间: ${gameState.currentRoomId}',
                        style: const TextStyle(fontSize: 16)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 构建环境描述区域，使用 `currentMapData` 的信息
  Widget _buildEnvironmentDescription(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
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
                _generateEnvironmentDescription(gameState.currentMap),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  // 生成环境描述，根据当前地图的 NPC、敌人、道具等内容
  String _generateEnvironmentDescription(MapData mapData) {
    String description = '你现在位于 ${mapData.name}。\n';

    if (mapData.npcs != null && mapData.npcs!.isNotEmpty) {
      description += '这里有一些NPC: \n';
      for (var npc in mapData.npcs!) {
        description += '- ${npc.name} (${npc.role})\n';
      }
    }

    if (mapData.enemies != null && mapData.enemies!.isNotEmpty) {
      description += '危险! 周围有敌人: \n';
      for (var enemy in mapData.enemies!) {
        description += '- ${enemy.name}, 等级 ${enemy.level}\n';
      }
    }

    if (mapData.items != null && mapData.items!.isNotEmpty) {
      description += '这里有一些可以拾取的道具: \n';
      for (var item in mapData.items!) {
        description += '- ${item.name}: ${item.description}\n';
      }
    }

    return description;
  }

  // 构建动作按钮和指令区域
  Widget _buildActionsAndInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 动作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildExitButtons(context),
          ),
        ],
      ),
    );
  }

  // 根据地图的出入口构建按钮，并更新当前地图或房间数据
  List<Widget> _buildExitButtons(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    List<Widget> buttons = [];

    if (gameState.currentMap.exits.contains('北')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap(context, '北'),
        child: const Text('向北'),
      ));
    }

    if (gameState.currentMap.exits.contains('南')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap(context, '南'),
        child: const Text('向南'),
      ));
    }

    if (gameState.currentMap.exits.contains('东')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap(context, '东'),
        child: const Text('向东'),
      ));
    }

    if (gameState.currentMap.exits.contains('西')) {
      buttons.add(ElevatedButton(
        onPressed: () => _moveToNextMap(context, '西'),
        child: const Text('向西'),
      ));
    }

    // 如果当前地图有房间，添加房间进入的按钮
    if (gameState.currentMap.rooms != null &&
        gameState.currentMap.rooms!.isNotEmpty) {
      buttons.addAll(_buildRoomButtons(context));
    }

    return buttons;
  }

  // 构建进入房间的按钮
  List<Widget> _buildRoomButtons(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    List<Widget> roomButtons = [];

    for (var room in gameState.currentMap.rooms!) {
      roomButtons.add(ElevatedButton(
        onPressed: () => _enterRoom(context, room.id),
        child: Text('进入 ${room.id} 房间'),
      ));
    }

    return roomButtons;
  }

  // 移动到下一个地图
  void _moveToNextMap(BuildContext context, String direction) {
    final gameState = Provider.of<GameState>(context, listen: false);

    // 查找与当前地图相连的下一个地图
    for (var map in gameState.allMaps) {
      if (map.exits.contains(direction) &&
          map.name != gameState.currentMap.name) {
        gameState.moveToNextMap(map); // 更新当前地图
        break;
      }
    }
  }

  // 进入房间
  void _enterRoom(BuildContext context, String roomId) {
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.moveToNextRoom(roomId); // 更新当前房间
  }
}