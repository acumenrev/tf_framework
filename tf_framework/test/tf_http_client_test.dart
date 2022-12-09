import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:tf_framework/models/base_model.dart';
import 'package:tf_framework/network/tf_http_client.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  dio.httpClientAdapter = dioAdapter;
  late TFHTTPClient client = TFHTTPClient(dio: dio);
  String urlToMock = "https://google.com/user";
  group("HTTPClient", () {
    test("Success response", () async {
      dioAdapter.onGet(urlToMock, (server) {
        server.reply(200, {"message": "ok"});
      });

      final response =
          await client.fetch(path: urlToMock, method: TFHTTPMethod.get);

      expect(response.getResponse() != null, true);
      JSONData data = JSONData.from(response.getDecodedJsonResponse());
      debugPrint("response $data");
      expect(data["message"], "ok");
    });

    test("error 404", () async {
      dioAdapter.onGet(urlToMock, (server) {
        server.reply(404, {"message": "not_found"});
      });
      final response =
          await client.fetch(path: urlToMock, method: TFHTTPMethod.get);
      expect(response.getError() != null, true);
      expect(response.getError()?.statusCode, 404);

      JSONData data = JSONData.from(response.getDecodedJsonResponse());
      expect(data != null, true);
      expect(data["message"], "not_found");
    });

    test("error 500", () async {
      dioAdapter.onGet(urlToMock, (server) {
        server.reply(500, {"message": "internal server error"});
      });
      final response =
          await client.fetch(path: urlToMock, method: TFHTTPMethod.get);
      expect(response.getError() != null, true);
      expect(response.getError()?.statusCode, 500);

      JSONData data = JSONData.from(response.getDecodedJsonResponse());
      expect(data != null, true);
      expect(data["message"], "internal server error");
    });

    tearDown(() {
      dioAdapter.reset();
    });
  });
}
