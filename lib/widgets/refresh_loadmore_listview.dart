import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author sunxianglei
/// @date 2020/8/26
/// @desc

typedef RefreshCallBack = Future<void> Function();
typedef LoadMoreCallBack<LoadingMoreState> = Future<LoadingMoreState> Function();

enum LoadingMoreState {
  loading, // 正在加载时
  complete, // 加载完成
  fail, // 加载失败
  noData, // 没有更多数据了
  hide, // 隐藏布局
}

class RefreshLoadMoreIndicator extends StatefulWidget {

  RefreshCallBack onRefresh;
  LoadMoreCallBack onLoadMore;
  int itemCount;
  IndexedWidgetBuilder itemBuilder;


  RefreshLoadMoreIndicator({
    @required this.onRefresh,
    @required this.onLoadMore,
    @required this.itemCount,
    @required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() {
    return RefreshLoadMoreIndicatorState();
  }

}

class RefreshLoadMoreIndicatorState extends State<RefreshLoadMoreIndicator> {
  ScrollController _scrollController;
  LoadingMoreState _loadingMoreState;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // 如果处于非 LoadingMoreState.hide 状态，都不能再来第二次，否则会出现重复请求
        if (_loadingMoreState == LoadingMoreState.loading ||
            _loadingMoreState == LoadingMoreState.complete ||
            _loadingMoreState == LoadingMoreState.noData ||
            _loadingMoreState == LoadingMoreState.fail) {
          return;
        }
        // 把状态调整为 LoadingMoreState.loading，此时就会显示正在加载的布局
        setState(() {
          _loadingMoreState = LoadingMoreState.loading;
        });
      // 拿到使用者返回的加载状态
        Future<LoadingMoreState> future = widget.onLoadMore();
        future.then((state) {
          setState(() {
            _loadingMoreState = state;
          });
      // 展示500ms的布局后再隐藏 footView 布局
          Timer(Duration(milliseconds: 500), () {
            setState(() {
              _loadingMoreState = LoadingMoreState.hide;
            });
          });
        });
      }
    });
  }

  /// footView 根据不同的状态，决定是否显示转圈以及显示不同的文案
  Widget _buildFootView(String text) {
    return Container(
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loadingMoreState == LoadingMoreState.loading
                ? Container(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(text),
            )
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: Scrollbar(
          child: ListView.builder(
        itemCount: widget.itemCount + 1,
        itemBuilder: (context, index) {
          if (index == widget.itemCount) {
            if (_loadingMoreState == LoadingMoreState.loading) {
              return _buildFootView("正在加载");
            } else if (_loadingMoreState == LoadingMoreState.complete) {
              return _buildFootView("加载完成");
            } else if (_loadingMoreState == LoadingMoreState.fail) {
              return _buildFootView('加载失败');
            } else if (_loadingMoreState == LoadingMoreState.noData) {
              return _buildFootView('已经到底啦');
            } else {
              return Container();
            }
          }
          // 依然还是用使用者给的 item 布局，只是在此之前我们做了关于 footView 的处理。
          return widget.itemBuilder(context, index);
        },
        controller: _scrollController,
      )),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
