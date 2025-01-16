import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? weatherInfo;
  List<Map<String, String>> savedCities = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCitiesList = prefs.getStringList('savedCities') ?? [];
    setState(() {
      savedCities = savedCitiesList
          .map((e) => Map<String, String>.from(Uri.splitQueryString(e)))
          .toList();
    });
  }

  Future<void> _saveCity(Map<String, String> cityData) async {
    final prefs = await SharedPreferences.getInstance();
    final cityQuery = Uri(queryParameters: cityData).query;
    if (!savedCities.any((city) => city['name'] == cityData['name'])) {
      savedCities.add(cityData);
      await prefs.setStringList(
          'savedCities',
          savedCities
              .map((city) => Uri(queryParameters: city).query)
              .toList());
    }
    setState(() {});
  }

  Future<void> _searchCity() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir şehir adı girin!')),
      );
      return;
    }

    final weatherData = await WeatherService.fetchWeather(city);
    if (weatherData != null) {
      setState(() {
        weatherInfo = {
          'name': weatherData['name'],
          'temp': '${(weatherData['main']['temp'] as double).toStringAsFixed(2)}°C',
          'description': weatherData['weather'][0]['description'],
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şehir bulunamadı!')),
      );
    }
  }

  Future<void> _deleteCity(Map<String, String> city) async {
    final prefs = await SharedPreferences.getInstance();
    savedCities.remove(city);
    await prefs.setStringList(
        'savedCities',
        savedCities
            .map((city) => Uri(queryParameters: city).query)
            .toList());
    setState(() {});
  }

  Future<void> _logout() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _addCityToSavedList() async {
    if (weatherInfo != null) {
      await _saveCity({
        'name': weatherInfo!['name'],
        'temp': weatherInfo!['temp'],
        'description': weatherInfo!['description'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${weatherInfo!['name']} kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hoş Geldiniz!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Şehir Ara',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                onPressed: _searchCity,
                child: Text('Ara'),
              ),
            ),

            if (weatherInfo != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🌍 Şehir: ${weatherInfo!['name']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '🌡️ Sıcaklık: ${weatherInfo!['temp']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '☁️ Durum: ${weatherInfo!['description']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Icon(Icons.wb_sunny, size: 40), // Optional weather icon
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _addCityToSavedList,
                  child: Text('Kaydet'),
                ),
              ),
            ],
            Divider(height: 30, thickness: 2),

            Text(
              'Kayıtlı Şehirler:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: savedCities.length,
                itemBuilder: (context, index) {
                  final city = savedCities[index];
                  return ListTile(
                    title: Text('${city['name']} - ${city['description']}'),
                    subtitle: Text('Sıcaklık: ${city['temp']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCity(city),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: Text('Çıkış Yap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
