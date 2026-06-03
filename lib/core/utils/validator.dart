// File: lib/core/utils/validator.dart
import 'package:floreria_ajolote/core/constants/app_constants.dart';

class FormValidators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regular expression for email validation
    if (!RegExp(AppConstants.emailRegex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if validation passes
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Basic password validation: minimum 8 characters, at least one letter and one number
    if (!RegExp(AppConstants.passwordRegex).hasMatch(value)) {
      return 'Password must be at least 8 characters long and contain at least one letter and one number';
    }
    return null;
  }

  // Confirm Password validator (usually compared against the password field)
  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  // General name validator (for products, services, employees, etc.)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null;
  }

  // Price validator
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Please enter a valid positive price';
    }
    return null;
  }

  // Quantity validator
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Please enter a valid positive quantity';
    }
    return null;
  }

  // Phone number validator (basic)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Add more specific phone number regex if needed for your region
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }
}
