import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_wanandroid/data/bean/base_resp.dart';

/// @author sunxianglei
/// @date 2020/8/27
/// @desc Dio请求二次封装

const ERROR_CODE = "errorCode";
const ERROR_MSG = "errorMsg";
const DATA = "data";

class DioUtil {
  static DioUtil _instance;
  Dio _dio;
  BaseOptions _options = getDefOptions();
  bool _isDebug = true;

  factory DioUtil() => _newInstance();

  static DioUtil _newInstance() {
    if (_instance == null) {
      _instance = DioUtil._init();
    }
    return _instance;
  }

  static BaseOptions getDefOptions() {
    BaseOptions options = BaseOptions();
    options.contentType = "application/x-www-form-urlencoded";
    options.connectTimeout = 1000 * 30;
    options.receiveTimeout = 1000 * 30;
    return options;
  }

  DioUtil._init() {
    _dio = new Dio(_options);
  }

  Future<BaseResp<T>> get<T>(
      String path, {
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onReceiveProgress,
      }) {
    return request<T>(
      path,
      queryParameters: queryParameters,
      options: _checkOptions('GET', options),
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  Future<BaseResp<T>> post<T>(
      String path, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onSendProgress,
        ProgressCallback onReceiveProgress,
      }) {
    return request<T>(
      path,
      data: data,
      options: _checkOptions('POST', options),
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<BaseResp<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try{
      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _printHttpLog(response);
      int _errorCode;
      String _errorMsg;
      T _data;
      if(response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created){
          Map<String, dynamic> _dataMap = Map();
          if(response.data is Map){
            _dataMap = response.data;
          }else {
            if(null != response && null != response.data
                && response.data.toString().isNotEmpty){
              _dataMap = json.decode(response.data.toString());
            }
          }
          _errorCode = _dataMap[ERROR_CODE];
          _errorMsg = _dataMap[ERROR_MSG];
          _data = _dataMap[DATA];
      }
      return BaseResp(_errorCode, _errorMsg, _data);
    }on DioError catch(e){
      HttpError error = HttpError.dioError(e);
      BotToast.showText(text: error.msg);
    }catch(e){
      LogUtil.e(e, tag: "DioUtil");
    }
    return BaseResp(-1, "异常", null);
  }

  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    print("---------------Http Log--------------"
            "\n[statusCode]: " +
        response.statusCode.toString());
    _printDataStr("reqData: ", response.request.data);
    _printDataStr("response: ", response.data);
  }

  /// print Data Str.
  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   " + da.substring(0, 512));
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   " + da);
        da = "";
      }
    }
  }

  Options _checkOptions(method, options) {
    options ??= Options();
    options.method = method;
    return options;
  }
}


class HttpError {

  String code;
  String msg;

  HttpError.dioError(DioError error) {
    msg = error.message;
    switch(error.type){
      case DioErrorType.CONNECT_TIMEOUT:
        msg = "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        msg = "服务器异常，请稍后重试！";
        break;
      case DioErrorType.SEND_TIMEOUT:
        msg = "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.RESPONSE:
        msg = "服务器异常，请稍后重试！";
        break;
      case DioErrorType.CANCEL:
        msg = "请求已被取消，请重新请求";
        break;
      case DioErrorType.DEFAULT:
        msg = "网络异常，请稍后重试！";
        break;
    }
  }
}
