
abstract class ITFError {
  late int statusCode;
  late String message;
  late dynamic? data;
  late String domainName;
}

class TFError implements ITFError {
  @override
  late var data;

  @override
  late String message;

  @override
  late int statusCode;

  @override
  late String domainName;

  TFError({required this.statusCode, required this.message, required this.domainName , this.data});

  String toString() {
    return "status code: $statusCode, domain: $domainName, message: $message";
  }
}
