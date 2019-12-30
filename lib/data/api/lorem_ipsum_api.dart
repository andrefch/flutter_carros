import 'package:http/http.dart' as http show get;

class LoremIpsumApi {
  LoremIpsumApi._();

  static String _loremCached;

  static Future<String> getLoremIpsum() async {
    if ((_loremCached != null) && (_loremCached.isNotEmpty)) {
      return _loremCached;
    }

    final String url = "https://loripsum.net/api";

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final String lorem = response.body
            .replaceAll(RegExp(r'<\/?p>'), "")
            .trim();
        _loremCached = lorem;
        return lorem;
      }

      throw Exception("Failed to get Lorem Ipsum. (${response.statusCode})");
    } catch (error) {
      throw Exception("Failed to get Lorem Ipsum. $error");
    }
  }
}
