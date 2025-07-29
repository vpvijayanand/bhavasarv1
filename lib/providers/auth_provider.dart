import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isAdmin => _currentUser?.role == 'admin';

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        await _loadUserProfile(user.uid);
      } else {
        _setState(AuthState.unauthenticated);
        _currentUser = null;
      }
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      _setLoading(true);
      UserModel? userModel = await _authService.getUserProfile(uid);
      if (userModel != null) {
        _currentUser = userModel;
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to load user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _clearError();
      bool success = await _authService.sendOTP(phoneNumber);
      return success;
    } catch (e) {
      _setError('Failed to send OTP: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOTPAndRegister(String otp, String phoneNumber, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Verify OTP
      UserCredential? userCredential = await _authService.verifyOTP(otp);
      if (userCredential?.user != null) {
        // Create user profile
        UserModel newUser = UserModel(
          uid: userCredential!.user!.uid,
          mobileNumber: phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _authService.createUserProfile(newUser);
        _currentUser = newUser;
        _setState(AuthState.authenticated);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to verify OTP: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String phoneNumber, String password) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if phone number exists
      bool exists = await _authService.phoneNumberExists(phoneNumber);
      if (!exists) {
        _setError('Phone number not registered');
        return false;
      }

      // Send OTP for login
      bool otpSent = await _authService.sendOTP(phoneNumber);
      return otpSent;
    } catch (e) {
      _setError('Failed to login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyLoginOTP(String otp) async {
    try {
      _setLoading(true);
      _clearError();

      UserCredential? userCredential = await _authService.verifyOTP(otp);
      if (userCredential?.user != null) {
        await _loadUserProfile(userCredential!.user!.uid);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to verify login OTP: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Failed to logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}