import 'package:intl/intl.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  static String formatCurrency(int amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }
  
  static String getAgeDescription(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 365) % 30;
    
    if (years > 0) {
      return '$years tahun $months bulan';
    } else if (months > 0) {
      return '$months bulan $days hari';
    } else {
      return '$days hari';
    }
  }
  
  static double calculateBMI(double weight, double height) {
    // BMI = weight (kg) / (height (m) * height (m))
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }
  
  static String getNutritionalStatus(double bmi, int ageInMonths) {
    // Simplified nutritional status calculation
    // In real app, this would use WHO growth standards
    if (bmi < 16) return 'Gizi Buruk';
    if (bmi < 17) return 'Gizi Kurang';
    if (bmi < 18.5) return 'Beresiko Gizi Kurang';
    if (bmi < 25) return 'Gizi Baik';
    if (bmi < 30) return 'Beresiko Gizi Lebih';
    return 'Gizi Lebih';
  }
  
  static bool isEmailValid(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
  
  static bool isPhoneValid(String phone) {
    final regex = RegExp(r'^[0-9]{10,13}$');
    return regex.hasMatch(phone);
  }
}