import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanmint/utility/formatters/formatters.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String profilePicture;
  String gender;
  String role;
  String? userRatings;
  String? fcmToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.gender,
    required this.role,
    this.userRatings,
    this.fcmToken = "",
  });

  String get fullname => "$firstName $lastName";

  String get formattedPhoneNo => Formatters.formatPhoneNumber(phoneNumber);

  static List<String> nameParts(String fullName) => fullName.split(" ");

  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String userNameWithPrefix = "cwt_$camelCaseUsername";
    return userNameWithPrefix;
  }

  // Generic method to update a field by name
  void setFieldValue(String fieldName, String newValue) {
    switch (fieldName) {
      case 'FirstName':
        firstName = newValue;
        break;
      case 'LastName':
        lastName = newValue;
        break;
      case 'Username':
        username = newValue;
        break;
      case 'Email':
        email = newValue;
        break;
      case 'PhoneNumber':
        phoneNumber = newValue;
        break;
      case 'Gender':
        gender = newValue;
        break;
      default:
        throw 'Invalid field name: $fieldName';
    }
  }

  static UserModel empty() => UserModel(
        id: "",
        firstName: "",
        lastName: "",
        username: "",
        email: "",
        phoneNumber: "",
        gender: "",
        role: "",
        userRatings: "",
        profilePicture: "",
        fcmToken: "",
      );

  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "Username": username,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Gender": gender,
      "ProfilePicture": profilePicture,
      "Role": role,
      "UserRatings": userRatings,
      "FcmToken": fcmToken
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        id: document.id,
        firstName: data["FirstName"] ?? "",
        lastName: data["LastName"] ?? "",
        username: data["Username"] ?? "",
        email: data["Email"] ?? "",
        phoneNumber: data["PhoneNumber"] ?? "",
        gender: data["Gender"] ?? "",
        role: data["Role"] ?? "",
        userRatings: data["UserRatings"] ?? "0.0",
        profilePicture: data["ProfilePicture"] ?? "",
        fcmToken: data["FcmToken"] ?? "",
      );
    }
    return UserModel.empty();
  }
}
