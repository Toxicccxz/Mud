import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart';
import '../models/save_data.dart';

class SaveService {
  var logger = Logger();
  static const String _encryptionKey =
      'my32lengthsupersecretnooneknows1'; // 32位密钥

  // 获取存档文件路径
  Future<String> _getSaveFilePath(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/save_data_$index.json'; // 根据索引保存不同文件
  }

// 加密数据
  String _encryptData(String data) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromSecureRandom(16); // 使用随机生成的16字节初始化向量
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: iv);

    // 使用 JSON 结构来保存 IV 和加密后的数据
    final Map<String, String> encryptedMap = {
      'iv': iv.base64, // IV 编码成 Base64
      'data': encrypted.base64 // 加密的数据也编码成 Base64
    };

    return jsonEncode(encryptedMap); // 将 IV 和加密数据作为 JSON 保存
  }

// 解密数据
  String _decryptData(String encryptedDataWithIv) {
    final key = Key.fromUtf8(_encryptionKey);

    try {
      // 先将加密数据解析为 JSON 格式
      final Map<String, dynamic> encryptedMap = jsonDecode(encryptedDataWithIv);
      final ivBase64 = encryptedMap['iv']; // 从 JSON 中提取 IV
      final encryptedBase64 = encryptedMap['data']; // 从 JSON 中提取加密数据

      final iv = IV.fromBase64(ivBase64); // Base64 解码 IV
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      // 解密加密的数据
      final decrypted =
          encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: iv);
      return decrypted;
    } catch (e) {
      logger.e('解密过程中出错: $e');
      throw e;
    }
  }

  // 保存存档
  Future<void> saveGame(SaveData saveData, int index) async {
    final filePath = await _getSaveFilePath(index);
    final jsonData = jsonEncode(saveData.toJson());
    logger.d('保存存档: $jsonData');

    final encryptedData = _encryptData(jsonData); // 加密数据
    logger.d('加密后的数据: $encryptedData'); // 输出加密后的数据

    final file = File(filePath);
    await file.writeAsString(encryptedData); // 将加密后的数据写入文件
  }

  // 加载存档
  Future<SaveData?> loadGame(int index) async {
    try {
      final filePath = await _getSaveFilePath(index);
      final file = File(filePath);

      if (await file.exists()) {
        final encryptedData = await file.readAsString();
        logger.d('读取到加密数据: $encryptedData'); // 输出加密后的数据

        final decryptedData = _decryptData(encryptedData); // 尝试解密
        logger.d('解密后数据: $decryptedData'); // 输出解密后的内容

        final jsonData = jsonDecode(decryptedData); // 解析 JSON
        logger.d('解析的 JSON 数据: $jsonData');

        return SaveData.fromJson(jsonData); // 返回反序列化后的数据
      } else {
        logger.d('存档文件不存在: $filePath');
        return null; // 如果没有存档文件
      }
    } catch (e) {
      logger.e('加载存档出错: $e'); // 捕获并输出错误
      return null;
    }
  }

  // 删除存档
  Future<void> deleteSave(int index) async {
    final filePath = await _getSaveFilePath(index);
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }
}
