import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'str_hp.dart';
import 'fun_hp.dart';

//static class
class HttpHp {

  /// jwt token
  static String _token = '';

  static void setToken(String token) {
    _token = token;
  }

  //get api uri
  static Uri apiUri(String action) {
    return FunHp.isHttps
        ? Uri.https(FunHp.apiServer, action)
        : Uri.http(FunHp.apiServer, action);
  }

  static String apiUrl(String action) {
    var uri = apiUrl(action);
    return uri.toString();
  }

  static Future<String> getStr(String action, [Map<String, dynamic>? json]) async {
    return await _call(action, json);
  }

  static Future<Map<String, dynamic>> getJson(String action, [Map<String, dynamic>? json]) async {
    var jsonStr = await getStr(action, json);
    return jsonDecode(jsonStr);
  }

  static Future<Uint8List?> getFileBytes(String action, [Map<String, dynamic>? json]) async {
    var response = await getResponse(action, json);
    return (response == null)
      ? null
      : response.bodyBytes;
  }

  static Future<String> _call(String action, [Map<String, dynamic>? json]) async {
    var response = await getResponse(action, json);
    return (response == null)
      ? '' 
      : utf8.decode(response.bodyBytes);
  }

  static Future<http.Response?> getResponse(String action, [Map<String, dynamic>? json]) async {
    var body = (json == null) ? '' : jsonEncode(json);
    //var body = (json == null) ? {} : json;
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Access-Control-Allow-Origin': '*',
      //'Cache-Control': 'no-cache',
    };
    if (!StrHp.isEmpty(_token)) 
      headers['Authorization'] = 'Bearer ' + _token;

//var result = await getCurrentLocation().timeout(const Duration(seconds: 5, onTimeout: () => null));

    try {
      return await http.post(
        apiUri(action),
        headers: headers,
        body: body,
      )
      .timeout(const Duration(seconds: 20));
    /*
    } on TimeoutException {
      log('Error: 連線時間超過20秒。');
      return null;
    */
    } catch(e) {
      log('Error: $e');
      return null;
    }
  }

  static Future<void> saveImage(String url, String toDir) async {
    var uri = apiUri(url);
    var response = await http.get(uri);

    // Downloading
    final imageFile = File(FunHp.dirApp + toDir);
    await imageFile.writeAsBytes(response.bodyBytes);
  }

  /*
  //get public ip address
  static Future<String> getIp() async {
    if (isDev)
      return ':::1';

    var uri = Uri.https('api.ipify.org', '');
    var response = await http.get(uri);
    return (response.statusCode == 200)
        ? response.body
        : '';
  }
  */

} //class
