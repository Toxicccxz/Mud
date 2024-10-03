import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:martial_world/data/models/save_data.dart';

class SaveService {
  static const String _saveFileName = 'save_data.json';
  static const String _encryptionKey = 'my32lengthsupersecretnooneknows1'; // 32位密钥

  // 获取应用的文档目录
  Future<String> _getSaveFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_saveFileName';
  }

  // 加密数据
  String _encryptData(String data) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromLength(16); // 使用16字节的初始化向量
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  // 解密数据
  String _decryptData(String encryptedData) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromLength(16); // 使用与加密时相同的初始化向量
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv);
    return decrypted;
  }

  // 保存存档
  Future<void> saveGame(SaveData saveData) async {
    final filePath = await _getSaveFilePath();
    final jsonData = jsonEncode(saveData.toJson());
    final encryptedData = _encryptData(jsonData);

    final file = File(filePath);
    await file.writeAsString(encryptedData);
  }

  // 加载存档
  Future<SaveData?> loadGame() async {
    try {
      final filePath = await _getSaveFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final encryptedData = await file.readAsString();
        final decryptedData = _decryptData(encryptedData);
        final jsonData = jsonDecode(decryptedData);
        return SaveData.fromJson(jsonData);
      } else {
        return null; // 如果没有存档文件
      }
    } catch (e) {
      // 错误处理：文件可能被篡改或加密/解密出错
      print('加载存档出错: $e');
      return null;
    }
  }

  // 删除存档
  Future<void> deleteSave() async {
    final filePath = await _getSaveFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }
}