import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tf_framework/models/base_error.dart';

class TFNetworkResponseModel {
  Response? _response;
  TFError? _error;

  setResponse(Response res) {
    _response = res;
  }

  setError(TFError error) {
    _error = error;
  }

  Response? getResponse() {
    return _response;
  }

  TFError? getError() {
    return _error;
  }

  getDecodedJsonResponse() {
    if (getResponse() == null) {
      return null;
    }
    return jsonDecode(jsonEncode(getResponse()?.data));
  }
}
