import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String? userId;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDay;
  final int? age;
  final DateTime? period;

  UsersModel({
    this.userId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.birthDay,
    this.age,
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
      'age': age,
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 0,
      password: json['password'] ?? '',
      birthDay: json['birthDay'] is Timestamp
          ? (json['birthDay'] as Timestamp).toDate()
          : DateTime.parse(json['birthDay']),
      period: json['period'] is Timestamp
          ? (json['period'] as Timestamp).toDate()
          : DateTime.parse(json['period']),
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
      age: data['age'],
      period: data['period'],
    );
  }
}
