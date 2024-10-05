import 'package:flutter/material.dart';
import 'package:martial_world/data/models/save_data.dart';
import 'package:martial_world/data/models/map_model.dart'; // 导入地图模型

class GameScreen extends StatelessWidget {
  final SaveData saveData;
  final MapData currentMapData; // 当前地图的数据

  const GameScreen({super.key, required this.saveData, required this.currentMapData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('游戏 - ${saveData.playerName}'),
      ),
      body: Column(
        children: [
          // 顶部玩家信息区域
          _buildPlayerInfo(),
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
          Text('玩家: ${saveData.playerName}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('等级: ${saveData.playerLevel}', style: TextStyle(fontSize: 16)),
          Text('经验值: ${saveData.experiencePoints}', style: TextStyle(fontSize: 16)),
          Text('当前位置: ${saveData.currentMap}', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 构建环境描述区域，使用 `currentMapData` 的信息
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
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  // 生成环境描述，根据当前地图的 NPC、敌人、道具等内容
  String _generateEnvironmentDescription() {
    String description = '你现在位于 ${currentMapData.name}。\n';
    
    if (currentMapData.npcs != null && currentMapData.npcs!.isNotEmpty) {
      description += '这里有一些NPC: \n';
      for (var npc in currentMapData.npcs!) {
        description += '- ${npc.name} (${npc.role})\n';
      }
    }

    if (currentMapData.enemies != null && currentMapData.enemies!.isNotEmpty) {
      description += '危险! 周围有敌人: \n';
      for (var enemy in currentMapData.enemies!) {
        description += '- ${enemy.name}, 等级 ${enemy.level}\n';
      }
    }

    if (currentMapData.items != null && currentMapData.items!.isNotEmpty) {
      description += '这里有一些可以拾取的道具: \n';
      for (var item in currentMapData.items!) {
        description += '- ${item.name}: ${item.description}\n';
      }
    }

    return description;
  }

  // 构建动作按钮和指令输入区域，动态调整出入口
  Widget _buildActionsAndInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 指令输入框
          TextField(
            decoration: const InputDecoration(
              hintText: '输入指令...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              // 处理用户输入的指令
              print('用户输入了: $value');
            },
          ),
          const SizedBox(height: 10),
          // 动作按钮，动态显示出入口
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildExitButtons(),
          ),
        ],
      ),
    );
  }

  // 根据地图的出入口构建按钮
  List<Widget> _buildExitButtons() {
    List<Widget> buttons = [];
    
    if (currentMapData.exits.contains('北')) {
      buttons.add(ElevatedButton(
        onPressed: () {
          print('向北移动');
        },
        child: Text('向北'),
      ));
    }
    
    if (currentMapData.exits.contains('南')) {
      buttons.add(ElevatedButton(
        onPressed: () {
          print('向南移动');
        },
        child: Text('向南'),
      ));
    }
    
    if (currentMapData.exits.contains('东')) {
      buttons.add(ElevatedButton(
        onPressed: () {
          print('向东移动');
        },
        child: Text('向东'),
      ));
    }
    
    if (currentMapData.exits.contains('西')) {
      buttons.add(ElevatedButton(
        onPressed: () {
          print('向西移动');
        },
        child: Text('向西'),
      ));
    }
    
    return buttons;
  }
}