import 'dart:convert';

import 'package:currencytrade_manager_backend/web_start_config.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 对非open的接口的请求参数全部增加userId
    // if (!options.path.contains("open")) {
    //   options.queryParameters["userId"] = "xxx";
    // }

    // 头部添加token
    options.headers["Authorization"] = WebStartConfig().profile.token;

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理 例子: 统一格式，增加默认值
    // if (response.statusCode == 200) {
    //   response.data = DioResponse(code: 0, msg: "请求成功啦", data: response.data);
    // } else {
    //   response.data = DioResponse(code: 1, msg: "请求失败啦", data: response.data);
    // }

    // 对某些单独的url返回数据做特殊处理
    // if (response.requestOptions.baseUrl.contains("???????")) {
    //   //....
    // }
    // 根据公司的业务需求进行定制化处理
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      // 连接服务器超时
      case DioExceptionType.connectionTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 响应超时
      case DioExceptionType.receiveTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 发送超时
      case DioExceptionType.sendTimeout:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 请求取消
      case DioExceptionType.cancel:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      // 404/503错误
      case DioExceptionType.badResponse:
        {
          // 根据自己的业务需求来设定该如何操作,可以是弹出框提示/或者做一些路由跳转处理
        }
        break;
      case DioExceptionType.badCertificate:
        {}
        break;
      case DioExceptionType.connectionError:
        {}
        break;
      // other 其他错误类型
      case DioExceptionType.unknown:
        {}
        break;
    }
    LogUtil().d(
        "DioInterceptors - onError : err.type = ${err.type}, err.response = ${err.response.toString()}");
    super.onError(err, handler);
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}
