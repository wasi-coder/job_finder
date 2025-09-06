import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  auth.User? _user;
  User? _userModel;
  bool _isLoading = true;

  auth.User? get user => _user;
  User? get userModel => _userModel;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(auth.User? firebaseUser) async {
    _user = firebaseUser;
    if (firebaseUser != null) {
      await _loadUserData(firebaseUser.uid);
    } else {
      _userModel = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userModel = User.fromMap(doc.data()!);
        print('User data loaded successfully: ${_userModel!.name}');
      } else {
        print('User document not found in Firestore, creating default user');
        // Create a basic user model from Firebase Auth data
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null) {
          _userModel = User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? 'User',
            email: firebaseUser.email ?? '',
            phone: '',
            role: 'seeker', // default role
            createdAt: DateTime.now(),
          );
          // Save the user to Firestore
          await _firestore.collection('users').doc(uid).set(_userModel!.toMap());
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Fallback: create user from Firebase Auth
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        _userModel = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          phone: '',
          role: 'seeker',
          createdAt: DateTime.now(),
        );
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        final userModel = User(
          id: result.user!.uid,
          name: name,
          email: email,
          phone: phone,
          role: role,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userModel.toMap());
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile(User updatedUser) async {
    if (_user != null) {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update(updatedUser.toMap());
      _userModel = updatedUser;
      notifyListeners();
    }
  }
}