import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'str_hp.dart';

//static class, cannot use _Fun
class FunHp {
  /// appBar pager button gap
  static const EdgeInsets PageBtnGap =
      const EdgeInsets.all(15); 

  //=== input parameters ===
  /// api is https or not
  static bool isHttps = false; 
  /// api server
  static String apiServer = ''; 

  /// login status
  static bool isLogin = false; 
  /// app dir
  static String dirApp = '';

  /// initial
  static Future init(bool isHttps, String apiServer) async {
    if (!StrHp.isEmpty(FunHp.apiServer))
      return;

    FunHp.isHttps = isHttps;
    FunHp.apiServer = apiServer;

    var dir = await getApplicationDocumentsDirectory();
    dirApp = dir.path + '/';
  }

} //class
