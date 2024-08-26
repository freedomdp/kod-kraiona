import 'package:flutter/material.dart';

class AppTheme {
  // Цвета
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color secondaryTextColor = Colors.black54;
  static const Color errorColor = Colors.red;
  static const Color tableHeaderColor = Colors.grey;
  // Размеры
  static const double maxWidth = 400.0;
  static const double borderRadius = 8.0;
  static const double padding = 16.0;


  // Тема приложения
    static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 18, color: textColor),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: smallBodyStyle,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
      ),
    );
  }

  // Стили текста
  static const TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: secondaryTextColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle smallBodyStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );

  static const TextStyle errorMessageStyle = TextStyle(
    fontSize: 16,
    color: errorColor,
  );

  // Стили кнопок
  static ButtonStyle get primaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  // Стили контейнеров
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
