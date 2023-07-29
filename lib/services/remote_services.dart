import 'dart:async';

import 'package:dio/dio.dart' as dio;

class RemoteServices {
  static var client = dio.Dio();

  static Future<dynamic> fetchItems() async {
    String theUrl = 'https://hiring-test.stag.tekoapis.net/api/products';
    try {
      dio.Response response = await client.get(theUrl, options: dio.Options(headers: {'Content-Type': 'application/json'})).timeout(const Duration(seconds: 30));
      dynamic json = response.data;
      if (response.statusCode == 200) {
        return json;
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      return null;
    }
  }
  static Future<dynamic> fetchColors() async {
    String theUrl = 'https://hiring-test.stag.tekoapis.net/api/colors';
    try {
      dio.Response response = await client.get(theUrl, options: dio.Options(headers: {'Content-Type': 'application/json'})).timeout(const Duration(seconds: 30));
      dynamic json = response.data;
      if (response.statusCode == 200) {
        return json;
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      return null;
    }
  }

}
