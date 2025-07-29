import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<UserModel> _users = [];
  UserModel? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, int> _statistics = {};

  List<UserModel> get users => _users;
  UserModel? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, int> get statistics => _statistics;

  // Load all users (for admin)
  void loadUsers() {
    _firestoreService.getAllUsers().listen(
          (users) {
        _users = users;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load users: $error');
      },
    );
  }

  // Get specific user
  Future<void> getUserById(String uid) async {
    try {
      _setLoading(true);
      UserModel? user = await _firestoreService.getUser(uid);
      _selectedUser = user;
    } catch (e) {
      _setError('Failed to get user: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      _setLoading(true);
      await _firestoreService.updateUser(user);

      // Update local lists
      int index = _users.indexWhere((u) => u.uid == user.uid);
      if (index != -1) {
        _users[index] = user;
      }
      if (_selectedUser?.uid == user.uid) {
        _selectedUser = user;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load statistics
  Future<void> loadStatistics() async {
    try {
      _statistics = await _firestoreService.getUserStatistics();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load statistics: $e');
    }
  }

  // Filter users
  List<UserModel> filterUsers({
    String? searchQuery,
    String? gender,
    String? rashi,
    String? communitySubGroup,
  }) {
    List<UserModel> filtered = List.from(_users);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.fullName?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
            user.mobileNumber.contains(searchQuery) ||
            user.email?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
      }).toList();
    }

    if (gender != null && gender.isNotEmpty) {
      filtered = filtered.where((user) => user.gender == gender).toList();
    }

    if (rashi != null && rashi.isNotEmpty) {
      filtered = filtered.where((user) => user.rashi == rashi).toList();
    }

    if (communitySubGroup != null && communitySubGroup.isNotEmpty) {
      filtered = filtered.where((user) => user.communitySubGroup == communitySubGroup).toList();
    }

    return filtered;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}