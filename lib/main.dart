import 'package:flutter/material.dart';
import 'screens/main_weather_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env file doesn't exist, print a helpful message
    print("Warning: .env file not found. Please create one from .env.example");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.blue,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const MainWeatherScreen(),
    );
  }
}
