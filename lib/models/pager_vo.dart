import 'dart:convert';
//import 'pager_row_dto.dart';

class PagerVo<T> {
  ///same to jQuery DataTables
  final int draw;
  ///return totalRows
  final int recordsFiltered;
  ///return page rows
  final List<T> data;

  PagerVo({required this.draw, required this.recordsFiltered, required this.data});

  ///convert json string to PagerVo model
  ///@jsonStr
  ///@fromJson static function parameter !!
  factory PagerVo.fromJson(String jsonStr, Function fromJson) {
    var json = jsonDecode(jsonStr);
    var list = (json['data'] == null) ? [] : json['data'] as List;
    var rows = list.map((row) => fromJson(row)).cast<T>().toList(); //has cast<>

    /* same result
    List<T> rows = [];
    var len = list.length;
    for (var i = 0; i < len; i++) {
      var item = fromJson(list[i]);
      rows.add(item as T);
    }
    */

    return PagerVo(
      draw: json['draw'],
      recordsFiltered: json['recordsFiltered'],
      data: rows,
    );
  }
}