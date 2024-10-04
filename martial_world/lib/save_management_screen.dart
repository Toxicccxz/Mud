import 'package:flutter/material.dart';
import 'package:martial_world/data/models/save_data.dart';
import 'package:martial_world/data/services/save_service.dart';
import 'package:martial_world/game_screen.dart'; // 导入游戏主界面

class SaveManagementScreen extends StatefulWidget {
  const SaveManagementScreen({super.key});

  @override
  SaveManagementScreenState createState() => SaveManagementScreenState();
}

class SaveManagementScreenState extends State<SaveManagementScreen> {
  List<String?> saves = List<String?>.filled(3, null); // 初始化3个空存档槽位
  final SaveService saveService = SaveService();

  @override
  void initState() {
    super.initState();
    _loadSaves(); // 加载存档数据
  }

  // 加载存档数据
  void _loadSaves() async {
    for (int i = 0; i < saves.length; i++) {
      SaveData? saveData = await saveService.loadGame(i); // 为每个槽位加载存档
      if (saveData != null) {
        setState(() {
          saves[i] = saveData.playerName; // 从本地加载的存档名称
        });
      }
    }
  }

  // 创建存档弹窗
  void _showCreateDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('创建新存档'),
          content: const Text('你确定要创建一个新的存档吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                // 创建并保存新的存档
                SaveData newSaveData = SaveData(
                  playerName: 'player ${index + 1}',
                  playerLevel: 1,
                  experiencePoints: 0,
                  currentMap: '起始村庄',
                  gameState: {}, // 初始化游戏状态
                );
                await saveService.saveGame(newSaveData, index); // 按索引保存存档

                setState(() {
                  saves[index] = '存档 ${index + 1}'; // 创建存档
                });
                Navigator.of(context).pop(); // 关闭弹窗
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 删除存档弹窗
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除存档'),
          content: Text('你确定要删除存档 ${index + 1} 吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                await saveService.deleteSave(index); // 删除存档

                setState(() {
                  saves[index] = null; // 删除存档
                });
                Navigator.of(context).pop(); // 关闭弹窗
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 载入存档弹窗
  void _showLoadDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('载入存档'),
          content: Text('你确定要载入存档 ${index + 1} 吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                // 加载存档并导航到游戏主界面
                SaveData? saveData = await saveService.loadGame(index); // 加载对应存档
                if (saveData != null) {
                  Navigator.of(context).pop(); // 关闭弹窗
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(saveData: saveData), // 导航到主游戏界面
                    ),
                  );
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '选择存档:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              width: 300, // 限定列表宽度
              child: ListView.builder(
                shrinkWrap: true, // 让列表适应内容
                itemCount: saves.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(saves[index] ?? '空存档 ${index + 1}'),
                    onTap: () {
                      if (saves[index] == null) {
                        _showCreateDialog(index); // 创建存档
                      } else {
                        _showLoadDialog(index); // 载入存档
                      }
                    },
                    trailing: saves[index] != null
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteDialog(index); // 删除存档
                            },
                          )
                        : null, // 空存档不显示删除按钮
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}