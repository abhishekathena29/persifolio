import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  static Future<AuthResult> signInWithEmailPassword(
      String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _createOrUpdateUserProfile(result.user!);
        return AuthResult.success(result.user!);
      }

      return AuthResult.failure('Login failed');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  // Sign up with email and password
  static Future<AuthResult> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Update display name
        await result.user!.updateDisplayName(name);

        // Create user profile in Firestore
        await _createOrUpdateUserProfile(result.user!, name: name);

        return AuthResult.success(result.user!);
      }

      return AuthResult.failure('Sign up failed');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  // Sign in with Google
  static Future<AuthResult> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult.failure('Google sign-in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      final UserCredential result =
          await _auth.signInWithCredential(credential);

      if (result.user != null) {
        await _createOrUpdateUserProfile(result.user!);
        return AuthResult.success(result.user!);
      }

      return AuthResult.failure('Google sign-in failed');
    } catch (e) {
      return AuthResult.failure('Google sign-in error: ${e.toString()}');
    }
  }

  // Sign out
  static Future<bool> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return true;
    } catch (e) {
      print('Sign out error: $e');
      return false;
    }
  }

  // Reset password
  static Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Create or update user profile in Firestore
  static Future<void> _createOrUpdateUserProfile(User user,
      {String? name}) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      final userData = {
        'uid': user.uid,
        'email': user.email,
        'name': name ?? user.displayName ?? 'User',
        'photoUrl': user.photoURL,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      if (!docSnapshot.exists) {
        userData['createdAt'] = FieldValue.serverTimestamp();
        userData['portfolioInitialized'] = false;
        userData['portfolioType'] = null;
        userData['assessmentCompleted'] = false;
      }

      await userDoc.set(userData, SetOptions(merge: true));
    } catch (e) {
      print('Error creating/updating user profile: $e');
    }
  }

  // Get user profile from Firestore
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUser == null) return null;

      final doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user portfolio type after assessment
  static Future<void> updateUserPortfolioType(String portfolioType) async {
    try {
      if (currentUser == null) return;

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'portfolioType': portfolioType,
        'assessmentCompleted': true,
        'portfolioAssignedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user portfolio type: $e');
    }
  }

  // Get Firebase Auth error message
  static String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final String message;
  final User? user;

  AuthResult._(this.isSuccess, this.message, this.user);

  factory AuthResult.success(User user) {
    return AuthResult._(true, 'Success', user);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(false, message, null);
  }
}
