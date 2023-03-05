import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../utils/constants.dart';

class InterceptorWrapper extends Interceptor {
  final Box<String>? box;
  final String token;
  InterceptorWrapper(this.box, this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final mToken = token.isEmpty ? "${box?.get(kTokenKey)}" : token;
    options.headers.addAll(kHeader(mToken));
    return handler.next(options); // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //debugPrint('http status code => ${response.statusCode} \nresponse data => ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    //debugPrint('have Error [${err.response?.statusCode}] => Data: ${err.response?.data}');
    super.onError(err, handler);
  }
}
