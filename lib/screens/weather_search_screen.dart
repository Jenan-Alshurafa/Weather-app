// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../widgets/glassmorphism_widget.dart';
import '../widgets/weather_card.dart';
import '../widgets/nav_bar_widget.dart';
import '../services/city_service.dart';
import 'main_weather_screen.dart';

class WeatherSearchScreen extends StatefulWidget {
  const WeatherSearchScreen({super.key});

  @override
  State<WeatherSearchScreen> createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _cities = [];
  bool _isLoading = false;
  bool _isAddingWeather = false;
  int currentIndex = 1;

  List<WeatherModel> weatherCards = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Earth background image
          Positioned.fill(
            child: Image.asset('assets/images/earth.png', fit: BoxFit.cover),
          ),
          // Gradient overlay with reduced opacity to show earth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                  const Color(0xFF16213E).withValues(alpha: 0.6),
                  const Color(0xFF0F3460).withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Status Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                ),

                // Navigation Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Weather',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Search for any city above to view its current weather',
                              ),
                              backgroundColor: const Color.fromARGB(
                                178,
                                255,
                                255,
                                255,
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Stack(
                    children: [
                      GlassmorphismWidget(
                        borderRadius: BorderRadius.circular(30),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search for a city',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          onChanged: (value) async {
                            if (value.length > 1) {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                final cities = await CityService.searchCities(
                                  value,
                                );
                                setState(() {
                                  _cities = cities;
                                  _isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  _cities = [];
                                  _isLoading = false;
                                });
                              }
                            } else {
                              setState(() {
                                _cities = [];
                              });
                            }
                          },
                          onSubmitted: (value) async {
                            if (value.trim().isEmpty) return;
                            await _addWeatherForCity(value.trim());
                          },
                        ),
                      ),
                      if (_isAddingWeather)
                        Positioned(
                          right: 15,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // City Results List
                if (_cities.isNotEmpty || _isLoading)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cities.length,
                            itemBuilder: (context, index) {
                              final city = _cities[index];
                              return ListTile(
                                title: Text(
                                  '${city['city']}, ${city['country']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () async {
                                  final lat = (city['latitude'] as num?)
                                      ?.toDouble();
                                  final lon = (city['longitude'] as num?)
                                      ?.toDouble();

                                  if (lat == null || lon == null) {
                                    _showErrorSnackBar(
                                      'إحداثيات المدينة غير متوفرة',
                                    );
                                    return;
                                  }

                                  final cityName =
                                      '${city['city']}, ${city['country']}';
                                  _searchController.clear();
                                  setState(() {
                                    _cities = [];
                                  });
                                  await _addWeatherCard(lat, lon, cityName);
                                },
                              );
                            },
                          ),
                  ),

                const SizedBox(height: 20),

                // Weather Cards List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    itemCount: weatherCards.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: WeatherCard(weather: weatherCards[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBarWidget(
        currentIndex: currentIndex,
        onHomeTap: () {
          setState(() => currentIndex = 0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainWeatherScreen()),
          );
        },
        onAddTap: () {
          setState(() => currentIndex = 1);
        },
      ),
    );
  }

  Future<void> _addWeatherForCity(String cityName) async {
    if (cityName.length < 2) return;

    setState(() {
      _isAddingWeather = true;
    });

    try {
      // Search for the city
      final cities = await CityService.searchCities(cityName);
      if (cities.isEmpty) {
        setState(() {
          _isAddingWeather = false;
        });
        _showErrorSnackBar('City not found');
        return;
      }

      // Take the first result
      final city = cities[0];
      final lat = (city['latitude'] as num?)?.toDouble();
      final lon = (city['longitude'] as num?)?.toDouble();

      if (lat == null || lon == null) {
        setState(() {
          _isAddingWeather = false;
        });
        _showErrorSnackBar('إحداثيات المدينة غير متوفرة');
        return;
      }

      final foundCityName = city['city'] as String? ?? 'Unknown';
      final countryName = city['country'] as String? ?? 'Unknown';
      final fullCityName = '$foundCityName, $countryName';

      await _addWeatherCard(lat, lon, fullCityName);
    } catch (e) {
      setState(() {
        _isAddingWeather = false;
      });
      _showErrorSnackBar('Error searching for city: $e');
    }
  }

  Future<void> _addWeatherCard(double lat, double lon, String cityName) async {
    try {
      final weatherData = await CityService.getWeather(lat, lon);

      // Extract weather information with null safety
      final main = weatherData['main'] as Map<String, dynamic>?;
      final weather = weatherData['weather'] as List<dynamic>?;

      if (main == null || weather == null || weather.isEmpty) {
        throw Exception('Invalid weather data structure');
      }

      final temp = (main['temp'] as num?)?.round() ?? 0;
      final weatherItem = weather[0] as Map<String, dynamic>;
      final condition = weatherItem['main'] as String? ?? 'Unknown';
      final highTemp = (main['temp_max'] as num?)?.round() ?? temp;
      final lowTemp = (main['temp_min'] as num?)?.round() ?? temp;

      // Map condition to icon
      final icon = _getWeatherIcon(condition);

      // Create weather model
      final weatherModel = WeatherModel(
        location: cityName,
        temperature: temp,
        condition: condition,
        highTemp: highTemp,
        lowTemp: lowTemp,
        weatherIcon: icon,
      );

      // Add to list
      setState(() {
        weatherCards.insert(0, weatherModel);
        _isAddingWeather = false;
        _searchController.clear();
        _cities = [];
      });
    } catch (e) {
      setState(() {
        _isAddingWeather = false;
      });
      _showErrorSnackBar('Error fetching weather: $e');
      print('Weather fetch error: $e'); // Debug output
    }
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/images/clear.gif';
      case 'clouds':
        return 'assets/images/cloudsun.gif';
      case 'rain':
      case 'drizzle':
        return 'assets/images/rainyy.gif';
      case 'windy':
        return 'assets/images/windy.gif';
      case 'snow':
        return 'assets/images/snowy.gif';
      case 'fog':
        return 'assets/images/foggy.gif';
      case 'haze':
        return 'assets/images/hazy.gif';
      case 'mist':
        return 'assets/images/misty.gif';
      case 'smoke':
        return 'assets/images/smoke.gif';
      case 'dust':
        return 'assets/images/dusty.gif';
      default:
        return 'assets/images/sun.gif';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
