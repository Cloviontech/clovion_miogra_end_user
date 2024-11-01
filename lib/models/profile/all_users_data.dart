// all_users_data
// To parse this JSON data, do
//
//     final allUsersData = allUsersDataFromJson(jsonString);

import 'dart:convert';

List<AllUsersData> allUsersDataFromJson(String str) => List<AllUsersData>.from(json.decode(str).map((x) => AllUsersData.fromJson(x)));

String allUsersDataToJson(List<AllUsersData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllUsersData {
    String? uid;
    String? email;
    String? phoneNumber;
    String? password;
    int? otp;
    int? userOtp;
    dynamic profilePicture;
    String? fullName;
    String? createdDate;
    dynamic latitude;
    dynamic longitude;
    AddressData? addressData;
    dynamic tempAddress;

    AllUsersData({
        this.uid,
        this.email,
        this.phoneNumber,
        this.password,
        this.otp,
        this.userOtp,
        this.profilePicture,
        this.fullName,
        this.createdDate,
        this.latitude,
        this.longitude,
        this.addressData,
        this.tempAddress,
    });

    factory AllUsersData.fromJson(Map<String, dynamic> json) => AllUsersData(
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
        // addressData: json["address_data"] == null ? null : AddressData.fromJson(json["address_data"]),
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
        "address_data": addressData?.toJson(),
        "temp_address": tempAddress,
    };
}

class AddressData {
    String? doorno;
    String? area;
    String? landmark;
    String? place;
    String? district;
    String? state;
    String? pincode;

    AddressData({
        this.doorno,
        this.area,
        this.landmark,
        this.place,
        this.district,
        this.state,
        this.pincode,
    });

    factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
        doorno: json["doorno"],
        area: json["area"],
        landmark: json["landmark"],
        place: json["place"],
        district: json["district"],
        state: json["state"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "doorno": doorno,
        "area": area,
        "landmark": landmark,
        "place": place,
        "district": district,
        "state": state,
        "pincode": pincode,
    };
}
