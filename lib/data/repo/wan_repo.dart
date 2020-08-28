

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_wanandroid/data/api/api.dart';
import 'package:flutter_wanandroid/data/bean/article_entity.dart';
import 'package:flutter_wanandroid/data/bean/base_resp.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';

/// @author sunxianglei
/// @date 2020/8/26
/// @desc

class WanRepo {

   Future<List<ArticleEntity>> getArticleList(int page) async {
      BaseResp<Map<String, dynamic>> resp = await DioUtil().get(Api.getPath(Api.ARTICLE, page: page));
      var articleEntityList = new List<ArticleEntity>();
      if(resp.errorCode == 0 && resp.data != null){
         Page page = Page.fromJson(resp.data);
         articleEntityList = page.datas.map((value) {
            return ArticleEntity().fromJson(value);
         }).toList();
      }else {
         BotToast.showText(text: resp.errorMsg);
      }
      return articleEntityList;
   }
}