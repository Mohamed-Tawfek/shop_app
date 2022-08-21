import 'package:dio/dio.dart';

import '../../component/constans.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));
  }

  static Future<Response> postData(
      {required endPoint,
      required Map<String, dynamic> data,
      String language = 'en',
      String? token}) async {
    dio!.options.headers = {
      'lang': language,
      'Content-Type': 'application/json',
      'Authorization': token
    };
    return await dio!.post(endPoint, data: data);
  }

static  Future<Response> getData({
    required String endPoint,
      String? token,
    String language = 'en',
  }) async {
    dio!.options.headers = {
      'lang': language,
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await dio!.get(endPoint);
  }
}
