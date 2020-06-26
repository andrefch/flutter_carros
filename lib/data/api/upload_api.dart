import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/util/http_helper.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  UploadService._();

  static const String URL_UPLOAD =
      'https://carros-springboot.herokuapp.com/api/v2/upload';

  static Future<ApiResult<String>> upload(File file) async {
    try {
      final String base64Image = convert.base64.encode(file.readAsBytesSync());
      String filename = path.basename(file.path);

      final headers = {'Content-Type': 'application/json'};

      final body = convert.json.encode({
        'fileName': filename,
        'mimeType': 'image/${_getFileExtension(filename)}',
        'base64': base64Image,
      });

      final response = await http.post(
        URL_UPLOAD,
        headers: headers,
        body: body,
      ).timeout(Duration(seconds: 60), onTimeout: () {
        print('Timeout!');
        throw SocketException('Não foi possível comunicar com o servidor.');
      });

      final Map bodyResponse = convert.json.decode(response.body);
      if (bodyResponse == null || bodyResponse.isEmpty) {
        return ApiResult.failure(
            'O servidor não conseguiu retornar a URL da imagem do veículo.');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String url = bodyResponse['url'] ?? '';
        if (url.isNotEmpty) {
          print('URL Image Car: $url');
          return ApiResult.success(url);
        } else {
          return ApiResult.failure("Não foi possível recuperar a URL da imagem do veículo.");
        }
      } else {
        return ApiResult.failure(bodyResponse['error']);
      }

      final responseData = convert.json.decode(response.body);
      return responseData['url'] ?? '';
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure("Não foi possível enviar a imagem para o servidor.");
    }
  }

  static String _getFileExtension(String filename) {
    if (filename == null) {
      return null;
    }
    String extension = path.extension(filename);
    if (extension.startsWith('\.') && extension.length > 1) {
      extension = extension.substring(1);
    }
    return extension;
  }
}
