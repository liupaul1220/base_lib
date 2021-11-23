import 'package:flutter/material.dart';

//pager service
class PagerSrv {

  //constant
  static const String First = 'F';
  static const String Prev = 'P';
  static const String Next = 'N';
  static const String Last = 'L';

  //static const EdgeInsets BtnGap = const EdgeInsets.all(5); 

  //#region input parameters
  ///action for read rows
  late Function _fnOnClick;
  ///rows count per page
  late int _pageRows;
  ///numeric button count
  late int _numBtns;
  ///show '[x]pages' or not
  late bool _showTotalPages;
  //#endregion

  //#region instance variables
  ///now page no, base 1
  int _nowPage = -1;  //-1 for checking in setPageVar()
  ///total rows, -1 mean
  late int _totalRows;
  ///total pages by _totalRows
  late int _totalPages;
  ///first page on form
  late int _firstPage;
  ///first page no max value
  late int _firstMax;
  ///last page on form
  late int _lastPage;

  late Color _textColor;
  late Color _textDisColor;
  late Color _textNowColor;
  late Color _btnBgColor;
  late TextStyle _textStyle;
  late TextStyle _textNowStyle;
  //#endregion 

  ///constructor
  PagerSrv(Function fnOnClick, {int pageRows = 10, int numBtns = 5, 
    bool showTotalPages = false, double fontSize = 15, 
    Color textColor = Colors.black, Color textDisColor = Colors.grey, 
    Color textNowColor = Colors.white, Color btnBgColor = Colors.blue
  }){
    _fnOnClick = fnOnClick;
    _pageRows = pageRows;
    _numBtns = numBtns;
    _showTotalPages = showTotalPages;

    _textColor = textColor;
    _textDisColor = textDisColor;
    _textNowColor = textNowColor;
    _btnBgColor = btnBgColor;

    _textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
    _textNowStyle = TextStyle(
      fontSize: fontSize,
      color: textNowColor,
    );

    reset();
  }

  ///show pager or not
  bool isShow(){
    return (_totalRows > 0);
  }

  ///get dataTable json object(Map) for find rows
  ///@findJson find json string
  ///@return dataTable json for find rows
  Map<String, dynamic> getDtJson([String findJson = '']) {
    return {
      'start': (_nowPage - 1) * _pageRows,
      'length': _pageRows,
      'recordsFiltered': _totalRows,
      'findJson': findJson,
    };
  }

  ///set totalRows
  void setTotalRows(int totalRows){
    //check
    if (totalRows == _totalRows)
      return;

    _totalRows = totalRows;
    _totalPages = (_totalRows <= 0) 
      ? 0 
      : _totalRows ~/ _pageRows + 
        (_totalRows % _pageRows > 0 ? 1 : 0);

    _firstMax = _totalPages - _numBtns + 1;
    if (_firstMax < 1)
      _firstMax = 1;

    setPageVar();
  }

  void reset(){
    _totalRows = -1;  //for recount
    _totalPages = 0;
    setPageVar(First);
  }

  ///return pager widget
  Padding getWidget() {
    //temp remark
    //add '[x]pages' if need
    //var result = Row();
    /*
    var widgets = <Widget>[];
    if (widget.showTotalPages){
      var hasRes = _totalRows % widget.pageRows > 0;
      var totalPages = _totalRows ~/ widget.pageRows + (hasRes ? 1 : 0);
      widgets.add(Text('{$totalPages}pages', style: _textStyle));
    }
    TextButton.styleFrom(
      backgroundColor: colorScheme.primary,
      shape: CircleBorder(),
    )    
    */

    //add first 2 buttons
    var btns = <Widget>[];
    var showFun = (_totalPages > _numBtns);
    bool status;
    if (showFun){
      status = (_firstPage > 1);
      btns.add(getButton(First, getIcon(Icons.skip_previous, status), status));
      btns.add(getButton(Prev, getIcon(Icons.navigate_before, status), status));
    }

    //num buttons
    for(var i = _firstPage; i <= _lastPage; i++){
      var fun = i.toString();
      btns.add((i == _nowPage)
        ? getButton(fun, Text(fun, style: _textNowStyle), true, _btnBgColor)
        : getButton(fun, Text(fun, style: _textStyle), true));
    }

    //last 2 buttons
    if (showFun){
      status = (_lastPage < _totalPages);
      btns.add(getButton(Next, getIcon(Icons.navigate_next, status), status));
      btns.add(getButton(Last, getIcon(Icons.skip_next, status), status));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: btns, 
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
    ));
  }

  Icon getIcon(IconData name, bool status){
    return Icon(
      name, 
      size: 20,
      color: status ? _textColor : _textDisColor,      
    );
  }

  CircleAvatar getButton(String fun, Widget icon, bool status, [Color? bgColor]){
    return CircleAvatar(
      radius: 17,
      backgroundColor: (bgColor == null) ? Colors.transparent : bgColor,
      child: IconButton(
        icon: icon,
        onPressed: () => status ? onClick(fun) : null,
      ),
    );
  }

  ///set nowPage, firstPage, lastPage
  ///@fun fun type, default to nowPage
  ///@return nowPage is changed or not
  bool setPageVar([String fun = '']) {
    if (fun == '')
      fun = _nowPage.toString();

    var nowPage = _nowPage;
    switch (fun) {
      case First:
        _nowPage = 1;
        _firstPage = 1;
        break;
      case Prev:
        _firstPage -= _numBtns;
        if (_firstPage < 1)
          _firstPage = 1;
        _nowPage = _firstPage + _numBtns - 1;
        if (_nowPage >= nowPage)
          _nowPage = nowPage - 1;
        break;
      case Next:
        _firstPage += _numBtns;
        if (_firstPage > _firstMax)
          _firstPage = _firstMax;
        _nowPage = _firstPage;
        if (_nowPage <= nowPage)
          _nowPage = nowPage +1;
        break;
      case Last:
        _nowPage = _totalPages;
        _firstPage = _firstMax;
        break;
      default:
        _nowPage = int.parse(fun);
        //firstPage did not change here !!
        break;
    }

    _lastPage = _firstPage + _numBtns - 1;
    if (_lastPage > _totalPages)
      _lastPage = _totalPages; 

    return (nowPage != _nowPage);
  }

  void onClick(String fun) {
    if (setPageVar(fun))
      _fnOnClick();
  }

} //class