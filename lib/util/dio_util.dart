import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import 'package:lu_master/config/constant.dart';
import 'package:lu_master/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioUtil {
  /// global dio object
  static Dio dio;

  /// default options
  static const String API_PREFIX = Constant.BASE_URL;
  static const int CONNECT_TIMEOUT = 60000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static Map request_sync(String url, {data, method}) {
    var res;
    Future<dynamic> future = Future(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("token");
    });
    future.then((value) async {
      print("token: " + value);
      data = data ?? {};
      method = method ?? GET;

      /// restful 请求处理
      /// /gysw/search/hist/:user_id        user_id=27
      /// 最终生成 url 为     /gysw/search/hist/27
      data.forEach((key, value) {
        if (url.indexOf(key) != -1) {
          url = url.replaceAll(':$key', value.toString());
        }
      });

      /// 打印请求相关信息：请求地址、请求方式、请求参数
      print('请求地址：【' + method + '  ' + url + '】');
      print('请求参数：' + data.toString());
      Dio dio = _createTokenInstance(value);
      var result;

      try {
        Future response = Future(() async {
          Response response = await dio.request(url,
              data: data, options: new Options(method: method));
          return response;
        });
        response.then((value) => {
              result = value.data,
            });
      } on DioError catch (e) {
        /// 打印请求失败相关信息
        print('请求出错：' + e.toString());
      }
      print("request result: " + result.toString());
      res = result;
    });
    print("request end");
    return res;
  }

  /// request method
  static Future<Map> request(String url, String content_type,
      {data, method}) async {
    String token = await Util.getString("token");
    data = data ?? {};
    method = method ?? GET;

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + url + '】');
    print('请求参数：' + data.toString());
    Dio dio = createInstance(token, content_type);
    var result;
    try {
      Response response = await dio.request(url,
          data: data, options: new Options(method: method));
      result = response.data;
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错：' + e.toString());
    }
    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance(String token, String contentType) {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
          baseUrl: API_PREFIX,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT,
          headers: {HttpHeaders.acceptHeader: "*", "token": token});
      dio = new Dio(options);
    }
    dio.options.contentType = contentType;
    dio.options.headers['token'] = token;
    print("header: " + dio.options.headers.toString());
    return dio;
  }

  /// 创建 dio 实例对象
  static Dio _createTokenInstance(String token) {
    // if (dio == null) {
    /// 全局属性：请求前缀、连接超时时间、响应超时时间
    BaseOptions options = BaseOptions(
        baseUrl: API_PREFIX,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        headers: {HttpHeaders.acceptHeader: "*", "token": token});
    print("header: " + options.headers.toString());
    dio = new Dio(options);
    // }
    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }

  ///post请求发送json
  static dynamic post(String url, String content_type,
      {Map<dynamic, dynamic> data}) async {
    // String token = await Util.getString("token");
    String token = Util.preferences.getString("token");
    Dio dio = createInstance(token, content_type);

    ///发起post请求
    Response response = await dio.post(url, queryParameters: data);
    return response.data;
  }

  ///get请求发送json
  static dynamic get(String url, String content_type,
      {Map<dynamic, dynamic> data}) async {
    String token = Util.preferences.getString("token");
    if (token == null) {
      token = Data.token;
    }
    if (token == null) {
      token = data['token'];
    }
    Dio dio = createInstance(token, content_type);

    ///发起post请求
    Response response = await dio.get(url, queryParameters: data);
    return response.data;
  }

  static dynamic uploadFile(
      String url, String content_type, FormData data) async {
    String token = Util.preferences.getString("token");
    Dio dio = createInstance(token, content_type);
    Response response = await dio.post(url, data: data);
    return response.data;
  }
}
