import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
  });

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      createdAt: DateTime.now(),
    );
  }
}

// RENAME THIS CLASS from AuthProvider to AuthService
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthService() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _user = AppUser.fromFirebase(firebaseUser);
        print('✅ User authenticated: ${_user?.email}');
      } else {
        _user = null;
        print('❌ No user signed in');
      }
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🔄 Creating account for: $email');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Account created successfully: ${userCredential.user?.uid}');

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      print('❌ Signup error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      print('❌ Unexpected signup error: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🔄 Signing in: $email');

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Signed in successfully');

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      print('❌ Signin error: ${e.code} - ${e.message}');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    print('✅ User signed out');
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}