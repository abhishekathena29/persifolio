import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/firebase_portfolio_model.dart';
import 'auth_service.dart';

class FirebasePortfolioService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _userId => _auth.currentUser?.uid ?? '';

  /// Get portfolio companies based on user's assessment result
  static Future<List<FirebasePortfolio>>
      getUserAssignedPortfolioCompanies() async {
    try {
      if (_userId.isEmpty) return [];

      // Get user profile to check portfolio type
      final userProfile = await AuthService.getUserProfile();
      if (userProfile == null || userProfile['portfolioType'] == null) {
        return [];
      }

      final portfolioType = userProfile['portfolioType'] as String;

      // Fetch all companies for this portfolio from Firebase collection
      final portfolioQuery = await _firestore
          .collection('portfolios')
          .where('portfolioName', isEqualTo: portfolioType)
          .get();

      return portfolioQuery.docs
          .map((doc) => FirebasePortfolio.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching user assigned portfolio companies: $e');
      return [];
    }
  }

  /// Get all companies for a portfolio by name
  static Future<List<FirebasePortfolio>> getPortfolioCompaniesByName(
      String portfolioName) async {
    try {
      final portfolioQuery = await _firestore
          .collection('portfolios')
          .where('portfolioName', isEqualTo: portfolioName)
          .get();

      return portfolioQuery.docs
          .map((doc) => FirebasePortfolio.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching portfolio companies by name: $e');
      return [];
    }
  }

  /// Group companies by sector split
  static Map<String, List<FirebasePortfolio>> groupCompaniesBySector(
      List<FirebasePortfolio> companies) {
    final Map<String, List<FirebasePortfolio>> grouped = {};

    for (final company in companies) {
      if (!grouped.containsKey(company.sectorSplit)) {
        grouped[company.sectorSplit] = [];
      }
      grouped[company.sectorSplit]!.add(company);
    }

    return grouped;
  }

  /// Convert grouped companies to portfolio sectors
  static List<PortfolioSector> convertToPortfolioSectors(
      Map<String, List<FirebasePortfolio>> groupedCompanies) {
    return groupedCompanies.entries
        .map((entry) => PortfolioSector.fromCompanies(entry.key, entry.value))
        .toList();
  }

  /// Stream portfolio companies for real-time updates
  static Stream<List<FirebasePortfolio>>
      getUserAssignedPortfolioCompaniesStream() {
    if (_userId.isEmpty) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .snapshots()
        .asyncMap((userDoc) async {
      if (!userDoc.exists || userDoc.data()?['portfolioType'] == null) {
        return <FirebasePortfolio>[];
      }

      final portfolioType = userDoc.data()!['portfolioType'] as String;

      final portfolioQuery = await _firestore
          .collection('portfolios')
          .where('portfolioName', isEqualTo: portfolioType)
          .get();

      return portfolioQuery.docs
          .map((doc) => FirebasePortfolio.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get all available portfolio companies
  static Future<List<FirebasePortfolio>> getAllPortfolioCompanies() async {
    try {
      final portfoliosSnapshot =
          await _firestore.collection('portfolios').get();

      return portfoliosSnapshot.docs
          .map((doc) => FirebasePortfolio.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching all portfolio companies: $e');
      return [];
    }
  }

  /// Check if user has completed assessment
  static Future<bool> hasUserCompletedAssessment() async {
    try {
      if (_userId.isEmpty) return false;

      final userProfile = await AuthService.getUserProfile();
      return userProfile?['assessmentCompleted'] == true;
    } catch (e) {
      print('Error checking assessment completion: $e');
      return false;
    }
  }

  /// Get user's portfolio type
  static Future<String?> getUserPortfolioType() async {
    try {
      if (_userId.isEmpty) return null;

      final userProfile = await AuthService.getUserProfile();
      return userProfile?['portfolioType'] as String?;
    } catch (e) {
      print('Error getting user portfolio type: $e');
      return null;
    }
  }
}
