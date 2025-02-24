import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String userId;
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final DateTime birthDay;
  final int age;

  UsersModel({
    required this.userId,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDay,
    required this.age,
  });

  Map<String, dynamic> toMap() {
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
    );
  }
}
