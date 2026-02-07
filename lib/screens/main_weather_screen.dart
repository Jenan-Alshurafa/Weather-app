import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../widgets/glassmorphism_widget.dart';
import '../widgets/nav_bar_widget.dart';
import 'weather_search_screen.dart';

class MainWeatherScreen extends StatefulWidget {
  const MainWeatherScreen({super.key});

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  bool isDaySelected = true;
  int currentIndex = 0;

  final WeatherModel currentWeather = WeatherModel(
    location: 'Dammam, Saudi Arabia',
    temperature: 20,
    condition: 'Windy',
    highTemp: 20,
    lowTemp: 4,
    weatherIcon: 'assets/images/windy.gif',
  );

  final List<HourlyWeather> hourlyForecast = [
    HourlyWeather(
      time: 'NOW',
      temperature: 20,
      weatherIcon: 'assets/images/rain2.gif',
      isNow: true,
    ),
    HourlyWeather(
      time: '11AM',
      temperature: 25,
      weatherIcon: 'assets/images/rainbow.gif',
    ),
    HourlyWeather(
      time: '12PM',
      temperature: 27,
      weatherIcon: 'assets/images/snowy.gif',
    ),
    HourlyWeather(
      time: '1PM',
      temperature: 29,
      weatherIcon: 'assets/images/papy.gif',
    ),
    HourlyWeather(
      time: '2PM',
      temperature: 31,
      weatherIcon: 'assets/images/rain3.gif',
    ),
  ];

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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                // Main Weather Display
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Weather Card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black.withValues(alpha: 0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Text
                                Text(
                                  currentWeather.location,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  '${currentWeather.temperature}°',
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                // Icon weather
                                Image.asset(
                                  currentWeather.weatherIcon,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  currentWeather.condition,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),

                        // Hourly Forecast
                        SizedBox(
                          height: 170,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: hourlyForecast.length,
                            itemBuilder: (context, index) {
                              final hour = hourlyForecast[index];
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 15),
                                child: GlassmorphismWidget(
                                  borderRadius: BorderRadius.circular(50),
                                  opacity: hour.isNow ? 0.3 : 0.2,
                                  borderColor: hour.isNow
                                      ? Colors.purple.withValues(alpha: 0.8)
                                      : Colors.white.withValues(alpha: 0.3),

                                  borderWidth: hour.isNow ? 2.0 : 1.0,
                                  child: Container(
                                    decoration: hour.isNow
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.purple.withValues(
                                                  alpha: 0.5,
                                                ),

                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          )
                                        : null,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          hour.time,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 14,
                                            fontWeight: hour.isNow
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 55,
                                          width: 55,
                                          child: Image.asset(
                                            hour.weatherIcon,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          '${hour.temperature}°',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return NavBarWidget(
      currentIndex: currentIndex,
      onHomeTap: () {
        setState(() => currentIndex = 0);
      },
      onAddTap: () {
        setState(() => currentIndex = 1);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WeatherSearchScreen()),
        );
      },
    );
  }
}
