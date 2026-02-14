import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'glassmorphism_widget.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Stack(
      children: [
        GlassmorphismWidget(
          borderRadius: BorderRadius.circular(25),
          opacity: 0.2,
          blur: 10.0,
          borderColor: Colors.white.withValues(alpha: 0.3),
          borderWidth: 1.0,
          child: SizedBox(
            height: 190,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Location
                  Text(
                    weather.location,
                    style: theme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(207, 255, 255, 255),
                      fontSize: 14,
                    ),
                  ),

                  /// Temperature + Condition (VERTICAL)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature}°',
                        style: theme.displaySmall?.copyWith(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.condition,
                        style: theme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  /// High / Low
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'H:${weather.highTemp}°  L:${weather.lowTemp}°',
                      style: theme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Icon INSIDE top-right corner
        Positioned(
          top: 12,
          right: 12,
          child: Image.asset(weather.weatherIcon, height: 80),
        ),
      ],
    );
  }
}
