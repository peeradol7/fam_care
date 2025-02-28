import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String? userId;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String authMethod;
  final DateTime? birthDay;
  final DateTime? period;

  UsersModel({
    this.userId,
    this.email,
    this.password,
    required this.authMethod,
    this.firstName,
    this.lastName,
    this.birthDay,
    this.period,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDay': birthDay?.toIso8601String(),
      'period': period?.toIso8601String(),
      'authMethod': authMethod,
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      password: json['password'] ?? '',
      birthDay: json['birthDay'] == null
          ? null
          : (json['birthDay'] is Timestamp
              ? (json['birthDay'] as Timestamp).toDate()
              : DateTime.tryParse(json['birthDay']) ?? DateTime(2000, 1, 1)),
      period: json['period'] == null
          ? null
          : (json['period'] is Timestamp
              ? (json['period'] as Timestamp).toDate()
              : DateTime.tryParse(json['period'] ?? '') ??
                  DateTime(2000, 1, 1)),
      authMethod: json['authMethod'],
    );
  }

  factory UsersModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UsersModel(
      userId: data['userId'],
      email: data['email'],
      password: data['password'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      birthDay: (data['birthDay'] as Timestamp).toDate(),
      period: data['period'],
      authMethod: data['authMethod'],
    );
  }
}
