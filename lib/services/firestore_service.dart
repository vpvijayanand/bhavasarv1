import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/rasi_model.dart';
import '../models/natchatiram_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList());
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(
        user.copyWith(updatedAt: DateTime.now()).toFirestore(),
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Rasi operations
  Stream<List<RasiModel>> getAllRasis() {
    return _firestore
        .collection('rasi')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => RasiModel.fromFirestore(doc))
        .toList());
  }

  Future<void> createRasi(RasiModel rasi) async {
    try {
      await _firestore.collection('rasi').add(rasi.toFirestore());
    } catch (e) {
      throw Exception('Failed to create rasi: $e');
    }
  }

  Future<void> updateRasi(String id, RasiModel rasi) async {
    try {
      await _firestore.collection('rasi').doc(id).update(
        rasi.toFirestore(),
      );
    } catch (e) {
      throw Exception('Failed to update rasi: $e');
    }
  }

  // Natchatiram operations
  Stream<List<NatchatiramModel>> getNatchatiramsByRasi(String rasiId) {
    return _firestore
        .collection('natchatiram')
        .where('rasiId', isEqualTo: rasiId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NatchatiramModel.fromFirestore(doc))
        .toList());
  }

  Stream<List<NatchatiramModel>> getAllNatchatirams() {
    return _firestore
        .collection('natchatiram')
        .where('isActive', isEqualTo: true)
        .orderBy('rasiName')
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NatchatiramModel.fromFirestore(doc))
        .toList());
  }

  Future<void> createNatchatiram(NatchatiramModel natchatiram) async {
    try {
      await _firestore.collection('natchatiram').add(natchatiram.toFirestore());
    } catch (e) {
      throw Exception('Failed to create natchatiram: $e');
    }
  }

  Future<void> updateNatchatiram(String id, NatchatiramModel natchatiram) async {
    try {
      await _firestore.collection('natchatiram').doc(id).update(
        natchatiram.toFirestore(),
      );
    } catch (e) {
      throw Exception('Failed to update natchatiram: $e');
    }
  }

  // Initialize default master data
  Future<void> initializeMasterData() async {
    try {
      // Check if rasi data already exists
      QuerySnapshot rasiSnapshot = await _firestore.collection('rasi').limit(1).get();
      if (rasiSnapshot.docs.isNotEmpty) return;

      // Default Rasi data
      List<Map<String, dynamic>> defaultRasis = [
        {'name': 'Mesha', 'nameInTamil': 'மேஷம்', 'order': 1},
        {'name': 'Rishabha', 'nameInTamil': 'ரிஷபம்', 'order': 2},
        {'name': 'Mithuna', 'nameInTamil': 'மிதுனம்', 'order': 3},
        {'name': 'Karkataka', 'nameInTamil': 'கர்கடகம்', 'order': 4},
        {'name': 'Simha', 'nameInTamil': 'சிம்மம்', 'order': 5},
        {'name': 'Kanya', 'nameInTamil': 'கன்னி', 'order': 6},
        {'name': 'Tula', 'nameInTamil': 'துலாம்', 'order': 7},
        {'name': 'Vrischika', 'nameInTamil': 'விருச்சிகம்', 'order': 8},
        {'name': 'Dhanus', 'nameInTamil': 'தனுசு', 'order': 9},
        {'name': 'Makara', 'nameInTamil': 'மகரம்', 'order': 10},
        {'name': 'Kumbha', 'nameInTamil': 'கும்பம்', 'order': 11},
        {'name': 'Meena', 'nameInTamil': 'மீனம்', 'order': 12},
      ];

      // Create Rasis
      Map<String, String> rasiIdMap = {};
      for (var rasiData in defaultRasis) {
        DocumentReference doc = await _firestore.collection('rasi').add({
          ...rasiData,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        rasiIdMap[rasiData['name']] = doc.id;
      }

      // Default Natchatiram data with their respective Rasi
      List<Map<String, dynamic>> defaultNatchatirams = [
        // Mesha Rasi
        {'name': 'Ashwini', 'nameInTamil': 'அஸ்வினி', 'rasi': 'Mesha', 'order': 1},
        {'name': 'Bharani', 'nameInTamil': 'பரணி', 'rasi': 'Mesha', 'order': 2},
        {'name': 'Krittika 1', 'nameInTamil': 'கிருத்திகை 1', 'rasi': 'Mesha', 'order': 3},

        // Rishabha Rasi
        {'name': 'Krittika 2,3,4', 'nameInTamil': 'கிருத்திகை 2,3,4', 'rasi': 'Rishabha', 'order': 1},
        {'name': 'Rohini', 'nameInTamil': 'ரோகிணி', 'rasi': 'Rishabha', 'order': 2},
        {'name': 'Mrigashira 1,2', 'nameInTamil': 'மிருகசீர்ஷம் 1,2', 'rasi': 'Rishabha', 'order': 3},

        // Mithuna Rasi
        {'name': 'Mrigashira 3,4', 'nameInTamil': 'மிருகசீர்ஷம் 3,4', 'rasi': 'Mithuna', 'order': 1},
        {'name': 'Ardra', 'nameInTamil': 'ஆர்த்ரா', 'rasi': 'Mithuna', 'order': 2},
        {'name': 'Punarvasu 1,2,3', 'nameInTamil': 'புனர்வசு 1,2,3', 'rasi': 'Mithuna', 'order': 3},

        // Karkataka Rasi
        {'name': 'Punarvasu 4', 'nameInTamil': 'புனர்வசு 4', 'rasi': 'Karkataka', 'order': 1},
        {'name': 'Pushya', 'nameInTamil': 'பூசம்', 'rasi': 'Karkataka', 'order': 2},
        {'name': 'Ashlesha', 'nameInTamil': 'ஆயில்யம்', 'rasi': 'Karkataka', 'order': 3},

        // Continue for other Rasis...
        // Simha Rasi
        {'name': 'Magha', 'nameInTamil': 'மகம்', 'rasi': 'Simha', 'order': 1},
        {'name': 'Purva Phalguni', 'nameInTamil': 'பூரம்', 'rasi': 'Simha', 'order': 2},
        {'name': 'Uttara Phalguni 1', 'nameInTamil': 'உத்திரம் 1', 'rasi': 'Simha', 'order': 3},
      ];

      // Create Natchatirams
      for (var natchatiramData in defaultNatchatirams) {
        String rasiName = natchatiramData['rasi'];
        String? rasiId = rasiIdMap[rasiName];

        if (rasiId != null) {
          await _firestore.collection('natchatiram').add({
            'name': natchatiramData['name'],
            'nameInTamil': natchatiramData['nameInTamil'],
            'rasiId': rasiId,
            'rasiName': rasiName,
            'order': natchatiramData['order'],
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to initialize master data: $e');
    }
  }

  // Statistics for admin dashboard
  Future<Map<String, int>> getUserStatistics() async {
    try {
      QuerySnapshot allUsers = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .get();

      QuerySnapshot adminUsers = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .where('role', isEqualTo: 'admin')
          .get();

      QuerySnapshot maleUsers = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .where('gender', isEqualTo: 'Male')
          .get();

      QuerySnapshot femaleUsers = await _firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .where('gender', isEqualTo: 'Female')
          .get();

      return {
        'totalUsers': allUsers.docs.length,
        'adminUsers': adminUsers.docs.length,
        'regularUsers': allUsers.docs.length - adminUsers.docs.length,
        'maleUsers': maleUsers.docs.length,
        'femaleUsers': femaleUsers.docs.length,
      };
    } catch (e) {
      return {
        'totalUsers': 0,
        'adminUsers': 0,
        'regularUsers': 0,
        'maleUsers': 0,
        'femaleUsers': 0,
      };
    }
  }
}