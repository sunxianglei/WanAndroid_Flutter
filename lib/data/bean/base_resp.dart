
/// @author sunxianglei
/// @date 2020/8/27
/// @desc 数据模型基类

class BaseResp<T> {
  int errorCode;
  String errorMsg;
  T data;

  BaseResp(this.errorCode, this.errorMsg, this.data);
}

class Page<T> {
  int curPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
  List datas;

  Page.fromJson(Map<String, dynamic> json){
    curPage = json['curPage'];
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
    datas = json['datas'];
  }
}