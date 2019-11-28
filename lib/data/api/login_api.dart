import 'dart:convert';

import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:http/http.dart' as http show get, post;

class LoginApi {
  static Future<ApiResult<User>> login(String username, String password) async {
    final url = "https://carros-springboot.herokuapp.com/api/v2/login";

    final params = json.encode({
      "username": username,
      "password": password,
    });

    final headers = {
      "Content-Type": "application/json"
    };

    try {
      final response = await http.post(
        url,
        body: params,
        headers: headers,
      );

      final Map<String, dynamic> responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        return ApiResult.success(User.fromJson(responseJson));
      }

      final String message = responseJson["error"] ??
          "Failed to login! Generic error!";
      return ApiResult.failure(message);
    } catch(error, exception) {
      print(error);
      print(exception);
      return ApiResult.failure("Failed to login! Unexpected failure!");
    }
  }
}
