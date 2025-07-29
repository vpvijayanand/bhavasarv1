import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String mobileNumber;
  final String? email;
  final String? fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? occupation;
  final String? city;
  final String? state;
  final String caste;
  final String? communitySubGroup;
  final String? annav;
  final String? kotiram;
  final String? rashi;
  final String? natchatiram;
  final String? profileImageUrl;
  final String role; // 'user' or 'admin'
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.mobileNumber,
    this.email,
    this.fullName,
    this.gender,
    this.dateOfBirth,
    this.occupation,
    this.city,
    this.state,
    this.caste = 'Bhavasara Chatriya Maratha',
    this.communitySubGroup,
    this.annav,
    this.kotiram,
    this.rashi,
    this.natchatiram,
    this.profileImageUrl,
    this.role = 'user',
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      mobileNumber: data['mobileNumber'] ?? '',
      email: data['email'],
      fullName: data['fullName'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth']?.toDate(),
      occupation: data['occupation'],
      city: data['city'],
      state: data['state'],
      caste: data['caste'] ?? 'Bhavasara Chatriya Maratha',
      communitySubGroup: data['communitySubGroup'],
      annav: data['annav'],
      kotiram: data['kotiram'],
      rashi: data['rashi'],
      natchatiram: data['natchatiram'],
      profileImageUrl: data['profileImageUrl'],
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mobileNumber': mobileNumber,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'occupation': occupation,
      'city': city,
      'state': state,
      'caste': caste,
      'communitySubGroup': communitySubGroup,
      'annav': annav,
      'kotiram': kotiram,
      'rashi': rashi,
      'natchatiram': natchatiram,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? uid,
    String? mobileNumber,
    String? email,
    String? fullName,
    String? gender,
    DateTime? dateOfBirth,
    String? occupation,
    String? city,
    String? state,
    String? caste,
    String? communitySubGroup,
    String? annav,
    String? kotiram,
    String? rashi,
    String? natchatiram,
    String? profileImageUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      state: state ?? this.state,
      caste: caste ?? this.caste,
      communitySubGroup: communitySubGroup ?? this.communitySubGroup,
      annav: annav ?? this.annav,
      kotiram: kotiram ?? this.kotiram,
      rashi: rashi ?? this.rashi,
      natchatiram: natchatiram ?? this.natchatiram,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}