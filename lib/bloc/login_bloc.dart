import 'dart:async';

import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/data/api/login_api.dart';
import 'package:flutter_carros/data/model/user.dart';

class LoginBloc {

  StreamController<User> _userStreamController = StreamController<User>();
  StreamController<bool> _progressStreamController = StreamController<bool>();

  Stream<User> get user => _userStreamController.stream;
  Stream<bool> get progress => _progressStreamController.stream;

  LoginBloc() {
    User.load().then((user) {
      if (user != null) {
        _userStreamController.add(user);
      }
    });
  }


  void login(String username, String password) async {
    try {
      _progressStreamController.add(true);
      final ApiResult<User> apiResult = await LoginApi.login(username, password);
      if (apiResult.success) {
        _userStreamController.add(apiResult.data);
      } else {
        _userStreamController.addError(Exception(apiResult.message));
      }
    } finally {
      _progressStreamController.add(false);
    }
  }

  void dispose() {
    _progressStreamController.close();
    _userStreamController.close();
  }
}