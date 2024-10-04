import 'package:flutter/material.dart';
import 'package:martial_world/data/models/save_data.dart';

class GameScreen extends StatelessWidget {
  final SaveData saveData;

  const GameScreen({super.key, required this.saveData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('游戏主界面 - ${saveData.playerName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('玩家: ${saveData.playerName}', style: TextStyle(fontSize: 24)),
            Text('等级: ${saveData.playerLevel}', style: TextStyle(fontSize: 20)),
            Text('经验值: ${saveData.experiencePoints}', style: TextStyle(fontSize: 20)),
            Text('当前位置: ${saveData.currentMap}', style: TextStyle(fontSize: 20)),
            // 添加游戏逻辑的其他显示组件
          ],
        ),
      ),
    );
  }
}
