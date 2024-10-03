import 'package:flutter/material.dart';

class SaveManagementScreen extends StatefulWidget {
  const SaveManagementScreen({super.key});

  @override
  SaveManagementScreenState createState() => SaveManagementScreenState();
}

class SaveManagementScreenState extends State<SaveManagementScreen> {
  List<String?> saves = List<String?>.filled(3, null); // 初始化3个空存档槽位

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
              onPressed: () {
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
              onPressed: () {
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