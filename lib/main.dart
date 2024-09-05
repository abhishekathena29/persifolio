import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persifolio/feature/auth/presentation/login.page.dart';
import 'package:persifolio/feature/home/presentation/home.page.dart';
import 'package:persifolio/feature/scoring/scoring_page.dart';
import 'package:persifolio/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

String b = "Aggressive Growth";
String c = "Income with Capital Preservation";
String d = "Income with Moderate Growth";
String e = "Growth with Income";
String f = "Growth";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        splitScreenMode: true,
        minTextAdapt: true,
        ensureScreenSize: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Persifolio',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: ScoringPage(score: 100),
          );
        });
  }
}
