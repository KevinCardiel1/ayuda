// File: lib/core/constants/app_constants.dart
// This file contains application-wide constants.

class AppConstants {
  // App Information
  static const String appTitle = 'Florería Ajolote';
  static const String appVersion = '1.0.0';

  // API Endpoints (if any)
  // static const String baseUrl = 'https://api.example.com';

  // Default values
  static const int defaultPageSize = 10; // Default items per page in lists
  static const String defaultImageUrl =
      'https://via.placeholder.com/150'; // Placeholder image URL

  // Regex patterns (can be moved to validator.dart if preferred)
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordRegex =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'; // Min 8 chars, at least one letter and one number

  // Authentication constants
  static const String adminRole = 'admin';
  static const String clientRole = 'client';

  // Paths for assets
  static const String animationPath = 'assets/animations/';
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';

  // Splash screen duration
  static const int splashScreenDuration = 3; // seconds

  static double? get defaultPadding => null;

}

class FirestoreCollections {
  static const String users = 'users';
  static const String products = 'products';
  static const String services = 'services';
  static const String orders = 'orders';
  static const String occasions = 'occasions';
  static const String employees = 'employees';
  static const String payments = 'payments';
}
