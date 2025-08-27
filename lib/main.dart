import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persifolio/feature/simulation/pages/simulation_home.dart';
import 'package:persifolio/firebase_options.dart';
import 'package:persifolio/feature/auth/presentation/login.page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persifolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF1A1A1A),
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey.shade500),
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade800,
          thickness: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(color: Colors.grey),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF1A1A1A),
          selectedColor: const Color(0xFF4CAF50),
          labelStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF4CAF50);
            }
            return Colors.grey;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF4CAF50);
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all(Colors.white),
          side: const BorderSide(color: Colors.grey),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFF4CAF50),
          inactiveTrackColor: Colors.grey.shade800,
          thumbColor: const Color(0xFF4CAF50),
          overlayColor: const Color(0xFF4CAF50).withOpacity(0.2),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Colors.grey;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFF4CAF50);
            }
            return Colors.grey.shade800;
          }),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF4CAF50),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
      ),
      home: const SimulationHomePage(),
    );
  }
}
