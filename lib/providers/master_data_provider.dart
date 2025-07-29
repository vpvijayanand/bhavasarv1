import 'package:flutter/material.dart';
import '../models/rasi_model.dart';
import '../models/natchatiram_model.dart';
import '../services/firestore_service.dart';

class MasterDataProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<RasiModel> _rasis = [];
  List<NatchatiramModel> _natchatirams = [];
  List<NatchatiramModel> _filteredNatchatirams = [];
  String? _selectedRasiId;
  bool _isLoading = false;
  String? _errorMessage;

  List<RasiModel> get rasis => _rasis;
  List<NatchatiramModel> get natchatirams => _natchatirams;
  List<NatchatiramModel> get filteredNatchatirams => _filteredNatchatirams;
  String? get selectedRasiId => _selectedRasiId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MasterDataProvider() {
    loadRasis();
    loadAllNatchatirams();
  }

  // Load all Rasis
  void loadRasis() {
    _firestoreService.getAllRasis().listen(
          (rasis) {
        _rasis = rasis;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load rasis: $error');
      },
    );
  }

  // Load all Natchatirams
  void loadAllNatchatirams() {
    _firestoreService.getAllNatchatirams().listen(
          (natchatirams) {
        _natchatirams = natchatirams;
        // If a rasi is selected, filter accordingly
        if (_selectedRasiId != null) {
          filterNatchatiramsByRasi(_selectedRasiId!);
        }
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to load natchatirams: $error');
      },
    );
  }

  // Filter Natchatirams by Rasi
  void filterNatchatiramsByRasi(String rasiId) {
    _selectedRasiId = rasiId;
    _filteredNatchatirams = _natchatirams
        .where((natchatiram) => natchatiram.rasiId == rasiId)
        .toList();
    notifyListeners();
  }

  // Clear Natchatiram filter
  void clearNatchatiramFilter() {
    _selectedRasiId = null;
    _filteredNatchatirams = [];
    notifyListeners();
  }

  // Get Rasi by ID
  RasiModel? getRasiById(String id) {
    try {
      return _rasis.firstWhere((rasi) => rasi.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Natchatiram by ID
  NatchatiramModel? getNatchatiramById(String id) {
    try {
      return _natchatirams.firstWhere((natchatiram) => natchatiram.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get Rasi name by ID
  String getRasiName(String? rasiId) {
    if (rasiId == null) return '';
    RasiModel? rasi = getRasiById(rasiId);
    return rasi?.name ?? '';
  }

  // Get Natchatiram name by ID
  String getNatchatiramName(String? natchatiramId) {
    if (natchatiramId == null) return '';
    NatchatiramModel? natchatiram = getNatchatiramById(natchatiramId);
    return natchatiram?.name ?? '';
  }

  // Create new Rasi (Admin only)
  Future<bool> createRasi(RasiModel rasi) async {
    try {
      _setLoading(true);
      await _firestoreService.createRasi(rasi);
      return true;
    } catch (e) {
      _setError('Failed to create rasi: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update Rasi (Admin only)
  Future<bool> updateRasi(String id, RasiModel rasi) async {
    try {
      _setLoading(true);
      await _firestoreService.updateRasi(id, rasi);
      return true;
    } catch (e) {
      _setError('Failed to update rasi: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create new Natchatiram (Admin only)
  Future<bool> createNatchatiram(NatchatiramModel natchatiram) async {
    try {
      _setLoading(true);
      await _firestoreService.createNatchatiram(natchatiram);
      return true;
    } catch (e) {
      _setError('Failed to create natchatiram: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update Natchatiram (Admin only)
  Future<bool> updateNatchatiram(String id, NatchatiramModel natchatiram) async {
    try {
      _setLoading(true);
      await _firestoreService.updateNatchatiram(id, natchatiram);
      return true;
    } catch (e) {
      _setError('Failed to update natchatiram: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Initialize master data (First time setup)
  Future<bool> initializeMasterData() async {
    try {
      _setLoading(true);
      await _firestoreService.initializeMasterData();
      return true;
    } catch (e) {
      _setError('Failed to initialize master data: $e');
      return false;
    } finally {
      _setLoading(false);
    }
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