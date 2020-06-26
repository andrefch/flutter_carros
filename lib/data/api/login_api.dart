import 'dart:convert' as converter;

import 'package:flutter_carros/constants.dart';
import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:flutter_carros/util/http_helper.dart' as http show post;
import 'package:flutter_carros/util/prefs.dart';

class LoginApi {
  LoginApi._();

  static Future<ApiResult<User>> login(String username, String password) async {
    final url = "https://carros-springboot.herokuapp.com/api/v2/login";

    final params = converter.json.encode({
      "username": username,
      "password": password,
    });

    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.post(
        url,
        body: params,
        headers: headers,
      );

      final Map<String, dynamic> json = converter.json.decode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromMap(json);
        user.save();
        
        return ApiResult.success(user);
      }

      Preferences.remove(Constants.KEY_USER);

      final String message = json["error"] ?? "Failed to login! Generic error!";
      return ApiResult.failure(message);
    } catch (error, exception) {
      print(error);
      print(exception);

      Preferences.remove(Constants.KEY_USER);
      return ApiResult.failure("Failed to login! Unexpected failure!");
    }
  }
}
