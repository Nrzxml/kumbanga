import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'KUMBANGA';
  static const String appTagline = 'Kunci Untuk Menumbuhkan Bangsa';
  
  // API Endpoints
  static const String baseUrl = 'https://api.kumbanga.com';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String childrenEndpoint = '$baseUrl/children';
  static const String growthDataEndpoint = '$baseUrl/growth-data';
  
  // App Settings
  static const int maxChildrenPerUser = 5;
  static const int checkinCooldownHours = 20;
  static const int pointsPerCheckin = 10;
  
  // Growth Chart Standards (WHO)
  static const Map<String, List<double>> weightForAgeBoys = {
    '3rd': [2.5, 3.4, 4.3, 5.0, 5.6, 6.1, 6.5],
    '50th': [3.3, 4.5, 5.6, 6.4, 7.0, 7.5, 7.9],
    '97th': [4.4, 5.8, 7.0, 8.0, 8.7, 9.3, 9.8],
  };
  
  static const Map<String, List<double>> heightForAgeBoys = {
    '3rd': [44.2, 48.9, 52.4, 55.3, 57.6, 59.6, 61.2],
    '50th': [46.1, 50.8, 54.7, 58.0, 60.6, 62.9, 64.9],
    '97th': [48.0, 52.8, 57.0, 60.6, 63.5, 66.0, 68.0],
  };
}

class AppColors {
  static const primary = Color(0xFF2E7D32);
  static const primaryLight = Color(0xFF60AD5E);
  static const primaryDark = Color(0xFF005005);
  static const accent = Color(0xFFFFC107);
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFB00020);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onBackground = Color(0xFF000000);
  static const onSurface = Color(0xFF000000);
  static const onError = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  
  static const headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  
  static const bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  
  static const bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
  
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );
}