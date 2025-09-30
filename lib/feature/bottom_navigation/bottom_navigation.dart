import 'package:flutter/material.dart';
import 'package:persifolio/feature/home/presentation/home.page.dart';
import 'package:persifolio/feature/simulation/pages/simulation_home.dart';
import 'package:persifolio/feature/assessment/page/assessment.page.dart';
import 'package:persifolio/feature/profile/profile_page.dart';

class BottomNavigationPage extends StatefulWidget {
  final String portfolioScoreName;
  final int initialIndex;

  const BottomNavigationPage({
    super.key,
    required this.portfolioScoreName,
    this.initialIndex = 0,
  });

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Home Page
          HomePage(portfolioScoreName: widget.portfolioScoreName),

          // Simulation Page
          const SimulationHomePage(),

          // Assessment Page
          const AssessmentPage(),

          // Profile Page
          ProfilePage(portfolioScoreName: widget.portfolioScoreName),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.trending_up_rounded,
                  label: 'Simulation',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.quiz_rounded,
                  label: 'Assessment',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color:
                    isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
