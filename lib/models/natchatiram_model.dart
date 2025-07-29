import 'package:cloud_firestore/cloud_firestore.dart';

class NatchatiramModel {
  final String id;
  final String name;
  final String nameInTamil;
  final String rasiId;
  final String rasiName;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  NatchatiramModel({
    required this.id,
    required this.name,
    required this.nameInTamil,
    required this.rasiId,
    required this.rasiName,
    required this.order,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NatchatiramModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NatchatiramModel(
      id: doc.id,
      name: data['name'] ?? '',
      nameInTamil: data['nameInTamil'] ?? '',
      rasiId: data['rasiId'] ?? '',
      rasiName: data['rasiName'] ?? '',
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
      'rasiId': rasiId,
      'rasiName': rasiName,
      'order': order,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}