import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tf_framework/models/base_error.dart';
import 'package:tf_framework/models/tf_network_response_model.dart';
import 'package:tf_framework/utils/tf_logger.dart';

enum TFHTTPMethod { get, post, patch, put, delete }

class TFS extends TFHTTPClient {}

class TFHTTPClient {
  late Dio _client;

  int getConnectTimeout() {
    return 30000; // 30s
  }

  int getReceiveTimeout() {
    return 3000; // 3s
  }

  TFHTTPClient({Dio? dio}) {
    if (dio == null) {
      _client = Dio(_dioOptions());
    } else {
      _client = dio;
    }

    _setupInterceptors();
  }

  setHttpClientAdapter(HttpClientAdapter? adapter) {
    _client.httpClientAdapter = adapter ?? DefaultHttpClientAdapter();
  }

  /// Setup Interceptor
  _setupInterceptors() {
    // Pretty Loggers
    _client.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
  }

  _convertHttpMethodEnumToString(TFHTTPMethod value) {
    switch (value) {
      case TFHTTPMethod.get:
        return "GET";
      case TFHTTPMethod.patch:
        return "PATCH";
      case TFHTTPMethod.delete:
        return "DELETE";
      case TFHTTPMethod.post:
        return "POST";
      case TFHTTPMethod.put:
        return "POT";
    }
  }

  setupCacheForBaseUrl(String url) {
    _client.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
  }

  _dioOptions() {
    var dioOptions = BaseOptions(
        connectTimeout: getConnectTimeout(),
        receiveTimeout: getReceiveTimeout());
    return dioOptions;
  }

  /// Make a network request
  ///
  /// [path] request route
  ///
  /// [headers] Custom headers for the request
  Future<TFNetworkResponseModel> fetch(
      {required String path,
      required TFHTTPMethod method,
      Map<String, dynamic>? headers,
      dynamic data}) async {
    var requestOptions = RequestOptions(
        path: path,
        method: _convertHttpMethodEnumToString(method),
        headers: headers,
        data: data);
    TFNetworkResponseModel networkResponse = TFNetworkResponseModel();
    try {
      Response res = await _client.fetch(requestOptions);
      networkResponse.setResponse(res);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.

      if (e.response != null) {
        networkResponse.setResponse(e.response!);
        TFLogger.logger.e(
            'Dio error! \nSTATUS: ${e.response?.statusCode}\nHEADERS: ${e.response?.headers}DATA: ${e.response?.data}');
      } else {
        // Error due to setting up or sending the request
        TFLogger.logger.e('Error sending request!', e.message);
      }

      TFError err = TFError.initFromDioError(e);
      networkResponse.setError(err);
    } catch (e) {
      rethrow;
    }
    return networkResponse;
  }
}
