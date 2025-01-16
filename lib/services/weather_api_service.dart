import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    try {
     final apiKey = 'e32d8990eeea173d1a1b578e8ce939ec';
final url = Uri.parse(
  'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }
}
