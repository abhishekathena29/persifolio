import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Invest by making portfolio',
            style: TextStyle(fontSize: 20.sp),
          ),
        ],
      ),
    );
  }
}
