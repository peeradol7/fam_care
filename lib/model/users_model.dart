import 'dart:convert';

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
      'age': age,
      "birthDay": birthDay?.toIso8601String(),
      "period": period?.toIso8601String(),
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      userId: json["userId"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      age: json["age"],
      password: json["password"],
      birthDay:
          json["birthDay"] != null ? DateTime.parse(json["birthDay"]) : null,
      period: json["period"] != null ? DateTime.parse(json["period"]) : null,
    );
  }
  String toJsonString() => json.encode(toJson());
}
