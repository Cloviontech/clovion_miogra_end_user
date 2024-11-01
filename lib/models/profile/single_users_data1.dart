// single_users_data


// To parse this JSON data, do
//
//     final singleUsersData = singleUsersDataFromJson(jsonString);

import 'dart:convert';

List<SingleUsersData> singleUsersDataFromJson(String str) => List<SingleUsersData>.from(json.decode(str).map((x) => SingleUsersData.fromJson(x)));

String singleUsersDataToJson(List<SingleUsersData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleUsersData {
    String uid;
    String email;
    String phoneNumber;
    String password;
    int otp;
    int userOtp;
    dynamic profilePicture;
    String fullName;
    String createdDate;
    dynamic latitude;
    dynamic longitude;
    dynamic addressData;
    dynamic tempAddress;

    SingleUsersData({
        required this.uid,
        required this.email,
        required this.phoneNumber,
        required this.password,
        required this.otp,
        required this.userOtp,
        required this.profilePicture,
        required this.fullName,
        required this.createdDate,
        required this.latitude,
        required this.longitude,
        required this.addressData,
        required this.tempAddress,
    });

    factory SingleUsersData.fromJson(Map<String, dynamic> json) => SingleUsersData(
        uid: json["uid"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        password: json["password"],
        otp: json["otp"],
        userOtp: json["user_otp"],
        profilePicture: json["profile_picture"],
        fullName: json["full_name"],
        createdDate: json["created_date"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        addressData: json["address_data"],
        tempAddress: json["temp_address"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "otp": otp,
        "user_otp": userOtp,
        "profile_picture": profilePicture,
        "full_name": fullName,
        "created_date": createdDate,
        "latitude": latitude,
        "longitude": longitude,
        "address_data": addressData,
        "temp_address": tempAddress,
    };
}
