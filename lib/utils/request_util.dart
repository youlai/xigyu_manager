//@dart=2.9
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xigyu_manager/api/api.dart';
import 'package:xigyu_manager/global/global.dart';
import 'package:xigyu_manager/pages/page_login.dart';
import 'package:xigyu_manager/utils/json_utils.dart';
import 'package:xigyu_manager/utils/utils.dart';
import 'package:xigyu_manager/widgets/loading_dialog.dart';

class RequestUtil {
  static BuildContext _context;
  static bool isShowing = false;
  static Dio _dio;
  static InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
//        print('=============================request============================');
//        print('url:${options.uri}');
//        print('method ${options.method}');
//        print('headers:${options.headers}');
//        print('data:\n${options.data}');
//        print('queryParameters:\n${options.queryParameters}');
    if (kDebugMode) {
      // JsonUtil.printJson(options.headers);
      // JsonUtil.printJson(options.data);
    }
    return handler.next(options);
  }, onResponse: (Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      JsonUtil.printRequest(response);
      JsonUtil.printRespond(response);
    }
//        print('=============================response============================');
//        print('url:${response.request.uri}');
//        debugPrint('response:${response.data}');
    return handler.next(response);
  }, onError: (DioError e, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('Error url:${e.requestOptions.uri}');
    }
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        showToast('网络连接超时，请稍后再试');
        break;
      case DioErrorType.sendTimeout:
        showToast('网络请求超时，请稍后再试');
        break;
      case DioErrorType.receiveTimeout:
        showToast('网络请求超时，请稍后再试');
        break;
      case DioErrorType.badResponse:
        showToast('服务器错误,${e.message}');
        break;
      case DioErrorType.cancel:
        showToast('请求已取消');
        break;
      case DioErrorType.unknown:
        showToast('网络错误，请检查网络连接或稍后再试');
        break;
      case DioErrorType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioErrorType.connectionError:
        // TODO: Handle this case.
        break;
    }
    hiddenLoadingDialog(_context);
    return handler.next(e);
  });
  static Dio getInstance() {
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      );
      _dio = Dio(options);
//      _dio.interceptors.add(LogInterceptor(
//        request : false,
//        requestHeader : false,
//        requestBody : true,
//        responseHeader : false,
//        responseBody : true,
//      )); //开启请求日志
      _dio.interceptors.add(interceptorsWrapper);
//      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//        // config the http client
//        client.findProxy = (uri) {
//          //proxy all request to localhost:8888
//          return "PROXY 192.168.101.63:8866";
//        };
//        client.badCertificateCallback =
//            (X509Certificate cert, String host, int port) => true;
//        // you can also create a new HttpClient to dio
//        // return new HttpClient();
//      };
    }
    return _dio;
  }

  ///请求api
  static Future<Map> request(String url,
      {Map<String, dynamic> data,
      method,
      baseUrl = true,
      Map<String, dynamic> queryParameters}) async {
    data = data ?? {};
    data['Token'] = token.value ?? '';
    method = method ?? "get";
    var dio = getInstance();
    if (baseUrl) {
      dio.options.baseUrl = Api.baseUrl;
    } else {
      dio.options.baseUrl = '';
    }
    dio.options.headers = {'content-type': 'application/x-www-form-urlencoded'};
    var res;
    if (method == "get") {
      var response = await dio.get(url);
      res = response.data;
    } else if (method == "post") {
      var response =
          await dio.post(url, data: data, queryParameters: queryParameters);
      res = response.data;
    }
//    print(res.toString());
    return res;
  }

  ///get
  static Future<Map> get(url, data, {baseUrl = true}) =>
      request(url, data: Map<String, dynamic>.from(data), baseUrl: baseUrl);

  ///post
  static Future<Map> post(url, data,
          {baseUrl = true, Map<String, dynamic> queryParameters}) =>
      request(url,
          data: Map<String, dynamic>.from(data),
          method: "post",
          baseUrl: baseUrl,
          queryParameters: queryParameters);
  static showLoadingDialog(BuildContext context) {
    _context = context;
    isShowing = true;
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return LoadingDialog(
            isCancel: true,
          );
        });
  }

  static hiddenLoadingDialog(BuildContext context) {
    if (context == null) return;
    if (isShowing) {
      Navigator.pop(context);
    }
    isShowing = false;
  }
}
