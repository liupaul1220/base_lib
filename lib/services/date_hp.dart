//library base_lib/services;

import 'package:intl/intl.dart';

//static class
class DateHp {
  static String _dtCsFormat = 'yyyy/MM/dd HH:mm:ss';

  //yyyy/MM/dd hh:mm
  static String format2(String dts) {
    //var format = 'yyyy-MM-dd HH:mm';
    var dt = DateFormat(_dtCsFormat).parse(dts);
    //var dt = dateFormat.parse(dts);
    return DateFormat('yyyy/MM/dd HH:mm').format(dt);
  }
} //class
