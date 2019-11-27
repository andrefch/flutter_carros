import 'package:http/http.dart' as http show get, post;

class LoginApi {
  static Future<bool> login(String username, String password) async {
    final url = "http://livrowebservices.com.br/rest/login";

    final params = {
      "login": username,
      "senha": password,
    };

    final response = await http.post(
      url,
      body: params,
    );

    return true;
  }
}
