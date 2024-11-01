// // To parse this JSON data, do
// //
// //     final singleUsersData = singleUsersDataFromJson(jsonString);

// import 'dart:convert';

// List<SingleUsersData> singleUsersDataFromJson(String str) => List<SingleUsersData>.from(json.decode(str).map((x) => SingleUsersData.fromJson(x)));

// String singleUsersDataToJson(List<SingleUsersData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class SingleUsersData {
//     String? uid;
//     String? email;
//     String? phoneNumber;
//     String? password;
//     int? otp;
//     int? userOtp;
//     dynamic profilePicture;
//     String? fullName;
//     String? createdDate;

//     SingleUsersData({
//         this.uid,
//         this.email,
//         this.phoneNumber,
//         this.password,
//         this.otp,
//         this.userOtp,
//         this.profilePicture,
//         this.fullName,
//         this.createdDate,
//     });

//     factory SingleUsersData.fromJson(Map<String, dynamic> json) => SingleUsersData(
//         uid: json["uid"],
//         email: json["email"],
//         phoneNumber: json["phone_number"],
//         password: json["password"],
//         otp: json["otp"],
//         userOtp: json["user_otp"],
//         profilePicture: json["profile_picture"],
//         fullName: json["full_name"],
//         createdDate: json["created_date"],
//     );

//     Map<String, dynamic> toJson() => {
//         "uid": uid,
//         "email": email,
//         "phone_number": phoneNumber,
//         "password": password,
//         "otp": otp,
//         "user_otp": userOtp,
//         "profile_picture": profilePicture,
//         "full_name": fullName,
//         "created_date": createdDate,
//     };
// }




// Define the User model class
class User {
  final String uid;
  final String email;
  final String phoneNumber;
  final String password;
  final int otp;
  final int userOtp;
  final String? profilePicture;
  final String fullName;
  final String createdDate;

  User({
    required this.uid,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.otp,
    required this.userOtp,
    required this.profilePicture,
    required this.fullName,
    required this.createdDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      otp: json['otp'],
      userOtp: json['user_otp'],
      profilePicture: json['profile_picture'],
      fullName: json['full_name'],
      createdDate: json['created_date'],
    );
  }
}