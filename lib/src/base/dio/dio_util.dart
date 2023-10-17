import 'dart:convert';

import 'package:currencytrade_manager_backend/web_start_config.dart';
import 'package:currencytrade_manager_backend/src/base/dio/base_response_entity.dart';
import 'package:currencytrade_manager_backend/src/base/dio/dio_interceptors.dart';
import 'package:currencytrade_manager_backend/src/base/dio/dio_method.dart';
import 'package:currencytrade_manager_backend/src/base/routers/router_path.dart'
    as route_path;
import 'package:currencytrade_manager_backend/src/constant/api.dart';
import 'package:currencytrade_manager_backend/src/utils/log_util.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

typedef ErrorResponseCallback = void Function(BaseResponseEntity res);

class DioUtil {
  /// 连接超时时间
  static const int CONNECT_TIMEOUT = 6;

  /// 响应超时时间
  static const int RECEIVE_TIMEOUT = 6;

  /// 请求的URL前缀
  static String BASE_URL = Api.BASE_URL;

  /// 是否开启网络缓存,默认false
  static bool CACHE_ENABLE = false;

  /// 最大缓存时间(按秒), 默认缓存七天,可自行调节
  static int MAX_CACHE_AGE = 7 * 24 * 60 * 60;

  /// 最大缓存条数(默认一百条)
  static int MAX_CACHE_COUNT = 100;

  static DioUtil? _instance;
  static Dio _dio = Dio();

  Dio get dio => _dio;

  DioUtil._internal() {
    _instance = this;
    _instance!._init();
  }

  factory DioUtil() => _instance ?? DioUtil._internal();

  static DioUtil? getInstance() {
    _instance ?? DioUtil._internal();
    return _instance;
  }

  /// 取消请求token
  final CancelToken _cancelToken = CancelToken();

  /// cookie
  // CookieJar cookieJar = CookieJar();

  // 原始baseOptions
  BaseOptions? originOptions;

  _init() {
    /// 初始化基本选项
    originOptions = BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: CONNECT_TIMEOUT),
      receiveTimeout: const Duration(seconds: RECEIVE_TIMEOUT),
    );

    /// 初始化dio
    _dio = Dio(originOptions);

    /// 添加拦截器
    _dio.interceptors.add(DioInterceptors());
    openPrettyLog();
    openFailRetry();

    /// 添加转换器
    // _dio.transformer = DioTransformer();

    // /// 添加cookie管理器
    // _dio.interceptors.add(CookieManager(cookieJar));
    //
    // /// 刷新token拦截器(lock/unlock)
    // _dio.interceptors.add(DioTokenInterceptors());
    //
    // /// 添加缓存拦截器
    // _dio.interceptors.add(DioCacheInterceptors());
  }

  /// 请求失败重试
  void openFailRetry() {
    // Add the interceptor
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print, // specify log function (optional)
        retries: 3, // retry count (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );
  }

  /// 设置Http代理(设置即开启)
  // void setProxy({
  //   String? proxyAddress,
  //   bool enable = false
  // }) {
  //   if (enable) {
  //     (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //         (HttpClient client) {
  //       client.findProxy = (uri) {
  //         return proxyAddress ?? "";
  //       };
  //       client.badCertificateCallback =
  //           (X509Certificate cert, String host, int port) => true;
  //     };
  //   }
  // }

  /// 设置https证书校验
  // void setHttpsCertificateVerification({
  //   String? pem,
  //   bool enable = false
  // }) {
  //   if (enable) {
  //     (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
  //       client.badCertificateCallback=(X509Certificate cert, String host, int port){
  //         if(cert.pem==pem){ // 验证证书
  //           return true;
  //         }
  //         return false;
  //       };
  //     };
  //   }
  // }

  /// 开启日志打印
  void openPrettyLog() {
    if (!WebStartConfig.isRelease) {
      _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        error: true,
        // responseHeader: true,
        // compact: true,
      ));
    }
  }

  /// 请求类
  Future<Object?> request(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    BaseOptions? baseOptions,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    ErrorResponseCallback? errorResCallback,
  }) async {
    if (baseOptions != null) {
      _dio.options = baseOptions;
    } else {
      _dio.options = originOptions!;
    }

    options ??= Options(method: methodValues[method]);
    options.method = methodValues[method];

    BaseResponseEntity apiResponse;
    try {
      Response response;
      response = await _dio.request(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      // LogUtil().d("dio - response = ${response.toString()}");
      if (response.statusCode != 200) {
        apiResponse = BaseResponseEntity(
            data: null,
            errCode: "${response.statusCode}",
            errMessage: "${response.statusMessage}",
            success: false);
        errorResCallback?.call(apiResponse);
        return null;
      } else {
        // response.data = {"errCode":"902","errMessage":"验证码不能为空","success":false}
        apiResponse = BaseResponseEntity.fromJson(response.data);
        if (apiResponse.data != null || (apiResponse.success ?? false)) {
          return apiResponse.data;
        } else {
          if (apiResponse.errCode == "5001") {
            // token过期
            goLoginPage();
          }
          errorResCallback?.call(apiResponse);
          return null;
        }
      }
    } on DioException catch (error) {
      LogUtil().e(
          "dio - response throw error = ${error.toString()}, error.response = ${error.response.toString()}");
      apiResponse = BaseResponseEntity(
          data: null,
          errCode: "${error.response?.data["status"]}",
          errMessage: error.response?.data["message"] ?? "未知错误",
          success: false);
      errorResCallback?.call(apiResponse);
      if (error.response?.data["status"] == 401) {
        // token过期
        goLoginPage();
      }
      return null;
    }
  }

  /// 取消网络请求
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  void goLoginPage() {
    WebStartConfig().profile.isLogin = false;
    WebStartConfig().profile.token = "";
    WebStartConfig().saveProfile();

    var context = WebStartConfig().globalStateKey.currentState?.context;
    if (context != null) {
      Future.delayed(const Duration(seconds: 0)).then((onValue) {
        GoRouter.of(context).go(route_path.loginPage);
      });
    }
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

const methodValues = {
  DioMethod.get: 'get',
  DioMethod.post: 'post',
  DioMethod.put: 'put',
  DioMethod.delete: 'delete',
  DioMethod.patch: 'patch',
  DioMethod.head: 'head'
};
