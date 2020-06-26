import 'package:flutter_carros/data/model/user.dart';
import 'package:http/http.dart' as http;

Future<http.Response> delete(String url,
    {Map<String, String> headers}) async {
  final completeHeaders = await _generateHeaders(customHeaders: headers);
  return await http.delete(
    url,
    headers: completeHeaders,
  );
}

Future<http.Response> get(String url, {Map<String, String> headers}) async {
  final completeHeaders = await _generateHeaders(customHeaders: headers);
  return await http.get(
    url,
    headers: completeHeaders,
  );
}

Future<http.Response> post(String url,
    {Map<String, String> headers, dynamic body}) async {
  final completeHeaders = await _generateHeaders(customHeaders: headers);
  return await http.post(
    url,
    headers: completeHeaders,
    body: body,
  );
}

Future<http.Response> put(String url,
    {Map<String, String> headers, dynamic body}) async {
  final completeHeaders = await _generateHeaders(customHeaders: headers);
  return await http.put(
    url,
    headers: completeHeaders,
    body: body,
  );
}

Future<Map<String, String>> _generateHeaders(
    {Map<String, String> customHeaders}) async {
  final authToken = await _getAuthorizationToken() ?? "";

  final headers = Map<String, String>();
  headers['Content-Type'] = 'application/json';
  if (authToken.trim().isNotEmpty) {
    headers['Authorization'] = 'Bearer $authToken';
  }
  return headers;
}

Future<String> _getAuthorizationToken() async {
  final user = await User.load();
  return user?.token;
}
