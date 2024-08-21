import 'dart:convert';
import 'dart:io';
import 'package:denvin_stock/components/helper/storage_helper.dart';
import 'package:denvin_stock/main.dart';
import 'package:denvin_stock/pages/app_routes.dart';
import 'package:get/get.dart' as getx;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' hide Response, HeaderValue, MultipartFile, FormData;

class Injector {
  static final Injector _singleton = Injector._internal();
  static final _dio = Dio();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();
  Dio getDio(){
    BaseOptions options = BaseOptions(receiveTimeout: const Duration(seconds: 60), connectTimeout: const Duration(seconds: 60),);
    _dio.options = options;
    _dio.options.followRedirects = false;
    _dio.options.headers["Content-Type"] = "application/json";
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.interceptors.clear();
    _dio.interceptors.add(LoggingInterceptors());
    return _dio;
  }

  static Options? getHeaderToken(){
    String? token = StorageHelper().getUserToken();
    if (token != null) {
      print("token=$token");
      var headerOptions = Options(headers: {
        "Authorization": "Bearer $token",
      });
      return headerOptions;
    }
    return null;
  }
}


class LoggingInterceptors extends Interceptor {

  String printObject(Object object) {
    Map jsonMapped = json.decode(json.encode(object));
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyPrint = encoder.convert(jsonMapped);
    return prettyPrint;
  }
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("--> ${options.method.toUpperCase()} ${"${options.baseUrl}${options.path}"}");
    print("Headers:");
    options.headers.forEach((k, v) => print('$k: $v'));
    print("queryParameters:");
    options.queryParameters.forEach((k, v) => print('$k: $v'));
    if (options.data != null) {
      try{
        FormData formData = options.data as FormData;
        print("Body:");
        var buffer = [];
        for(MapEntry<String, String> pair in formData.fields){
          buffer.add('${pair.key}:${pair.value}');
        }
        print("Body:{${buffer.join(', ')}}");
      }catch(e){
        print("Body: ${printObject(options.data)}");
      }
    }
    print("--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) {
    print("<-- ${dioError.message} ${(dioError.response?.requestOptions != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}");
    print("${dioError.response != null ? dioError.response!.data : 'Unknown Error'}");
    print("<-- End error");
    if(dioError.response?.statusCode==403  && getx.Get.currentRoute != AppRoutes.signUp) {
      MyApp.startFirstScreen(dioError.response?.data["message"]);
      return;
    }
    return super.onError(dioError, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("<-- ${response.statusCode} ${(response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL')}");
    print("Headers:");
    response.headers.forEach((k, v) => print('$k: $v'));
    print("Response: ${response.data}");
    print("<-- END HTTP");
    return super.onResponse(response, handler);
  }
}