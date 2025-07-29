import 'package:cloud_firestore/cloud_firestore.dart';

class RasiModel {
  final String id;
  final String name;
  final String nameInTamil;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  RasiModel({
    required this.id,
    required this.name,
    required this.nameInTamil,
    required this.order,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RasiModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RasiModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameInTamil: data['nameInTamil'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameInTamil': nameInTamil,
      'order': order,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}