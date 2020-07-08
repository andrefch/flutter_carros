import 'dart:convert';

import 'package:flutter_carros/util/prefs.dart';

import '../../constants.dart';

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String imageURL;
  final String token;
  final List<String> roles;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.imageURL,
      this.token,
      this.roles});

  User.fromMap(Map<String, dynamic> json)
      : this(
          id: json["id"],
          name: json["nome"],
          username: json["login"],
          email: json["email"],
          imageURL: json["urlFoto"],
          token: json["token"],
          roles: json["roles"]?.cast<String>() ?? List<String>(),
        );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.name;
    data['login'] = this.username;
    data['email'] = this.email;
    data['urlFoto'] = this.imageURL;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }

  static Future<User> load() async {
    final value = await Preferences.getString(Constants.KEY_USER, "");
    if (value.isNotEmpty) {
      return User.fromMap(json.decode(value));
    }
    return null;
  }

  void save() {
    Preferences.setString(Constants.KEY_USER, json.encode(toMap()));
  }

  static void clear() {
    Preferences.remove(Constants.KEY_USER);
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username, email: $email, imageURL: $imageURL, token: $token, roles: $roles}';
  }
}
