# WeatherApp

A simple and clean Weather Application built with Flutter, designed as a learning-focused project to understand API integration, asynchronous data handling, and dynamic UI updates.


# About the Project:

This project was developed to practice building a real-world Flutter application that consumes an external RESTful Weather API.
The app allows users to search for a city and retrieve its current weather data in real time.

The main motivation behind this project is to strengthen my understanding of API integration in Flutter and how mobile applications interact with external services.



# Objectives:

Learn how to create and structure a Flutter project properly

Integrate an external Weather API into a Flutter app

Send HTTP requests and handle responses

Parse JSON data and display it dynamically in the UI

Implement a search feature for city-based weather lookup

Handle user input errors (e.g. invalid city names)

Improve overall Flutter and Dart development skills



# What I learned:

How to use the http package to fetch data from an API

Working with asynchronous programming (async / await) in Dart

Handling API errors and edge cases gracefully

Managing dynamic data within Flutter widgets

Writing cleaner and more organized Flutter code

This project serves as a solid foundation for building more advanced Flutter applications that rely on real-time data.



# 🔑 API Keys Setup (Required)

**⚠️ Important: You must create your own API keys to use this application.**

For security reasons, API keys are not included in this repository. This prevents unauthorized usage, protects against API key abuse, and ensures each user manages their own API quotas and costs.

## Why API Keys Are Hidden?

- **Security**: Prevents exposure of sensitive credentials in public repositories
- **Cost Control**: Each developer manages their own API usage and billing
- **Best Practices**: Follows industry standards for handling API credentials
- **Rate Limiting**: Prevents shared keys from hitting rate limits

## Step-by-Step Setup:

### 1. Get Your API Keys

#### OpenWeatherMap API Key (for weather data):
1. Visit [OpenWeatherMap](https://home.openweathermap.org/users/sign_up)
2. Create a free account or sign in
3. Navigate to [API Keys](https://home.openweathermap.org/api_keys)
4. Generate a new API key (or use an existing one)
5. Copy your API key

#### RapidAPI Key (for city search):
1. Visit [RapidAPI](https://rapidapi.com/auth/sign-up)
2. Create a free account or sign in
3. Subscribe to the [GeoDB Cities API](https://rapidapi.com/wirefreethought/api/geodb-cities)
4. Navigate to your [RapidAPI Dashboard](https://rapidapi.com/developer/billing)
5. Copy your API key from the "Security" section

### 2. Configure Your API Keys

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Open the `.env` file** in the project root directory

3. **Replace the placeholder values** with your actual API keys:
   ```
   RAPIDAPI_KEY=your_rapidapi_key_here
   RAPIDAPI_HOST=wft-geo-db.p.rapidapi.com
   OPENWEATHER_API_KEY=your_openweather_api_key_here
   ```

4. **Save the file**

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Notes:

- The `.env` file is automatically ignored by Git (see `.gitignore`)
- Never commit your `.env` file to version control
- The `.env.example` file is a template and is safe to commit
- If you see errors about missing API keys, make sure your `.env` file exists and contains valid keys