import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String? userId;
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final DateTime birthDay;
  final int age;
  final DateTime? period;

  UsersModel({
    this.userId,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDay,
    required this.age,
    required this.period,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'birthDay': Timestamp.fromDate(birthDay),
      'age': age,
    };
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
