/// @author sunxianglei
/// @date 2020/8/28
/// @desc url、path常量类

class Api {

  static const BASE_URL = "https://www.wanandroid.com/";
  static const ARTICLE = "article/list/";
  static const RES_TYPE = "/json";
  static const BANNER = "banner/";

  static String getPath(String path, { int page }){
    StringBuffer sb = StringBuffer(BASE_URL);
    sb.write(path);
    if(page != null) {
      sb.write(page);
    }
    sb.write(RES_TYPE);
    return sb.toString();
  }
}