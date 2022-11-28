import 'dart:developer';
typedef JSONData = Map<String, dynamic>;

abstract class ITFModel {
  fromJson(JSONData json);
  JSONData? toJson();
}

class TFModel implements ITFModel {
  @override
  fromJson(JSONData json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  JSONData? toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  Object? toDebugString() {
    return inspect(this);
  }

}
