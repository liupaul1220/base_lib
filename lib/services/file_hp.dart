import 'dart:io';
import 'fun_hp.dart';

//static class
class FileHp {
  //check file existed under app folder
  static bool exist(String filePath) {
    return File(filePath).existsSync();
  }

  /*
  static bool dirExist(String dirPath) {
    return Directory(dirPath).existsSync();
  }
  */

  //dirPath: no tail '/'
  static bool dirExist(String dirPath) {
    return Directory(dirPath).existsSync();
  }

  //create folder if not exists
  //dirPath: no tail '/'
  static void createDir(String dirPath) {
    var dir = Directory(dirPath);
    if (!dir.existsSync()) dir.createSync();
  }

  //await _appDocDirFolder.create(recursive: true);

  /*
  static Future<String> getAppDir() async {
    var dir = await getApplicationDocumentsDirectory();
    return dir.path + '/';
  }

  static Future<String> getInfoPath() async {
    return await FileHp.getFilePath(FunHp.infoFile);
  }
  */

  static String getFilePath(String fileName) {
    return FunHp.dirApp + fileName;
  }
} //class
