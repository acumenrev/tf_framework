import 'package:dio/dio.dart';

abstract class ITFError {
  int? statusCode;
  String? message;
  late dynamic data;
  late String domainName;
}

class TFError implements ITFError {
  @override
  late var data;

  @override
  String? message;

  @override
  int? statusCode;

  @override
  late String domainName;

  TFError(
      {required this.statusCode,
      required this.message,
      required this.domainName,
      this.data});

  TFError.initFromDioError(DioError err) {
    if (err.response != null) {
      this.statusCode = err.response!.statusCode;
      this.message = err.response!.statusMessage;
      this.data = err.response!.data;
    }
  }

  String toString() {
    return "status code: $statusCode, domain: $domainName, message: $message";
  }
}
