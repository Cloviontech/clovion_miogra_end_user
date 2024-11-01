// To parse this JSON data, do
//
//     final foodAlldata = foodAlldataFromJson(jsonString);

import 'dart:convert';

List<FoodAlldata> foodAlldataFromJson(String str) => List<FoodAlldata>.from(json.decode(str).map((x) => FoodAlldata.fromJson(x)));

String foodAlldataToJson(List<FoodAlldata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodAlldata {
    String? businessId;
    String? foodId;
    String? sellerName;
    String? businessName;
    String? panNumber;
    String? gst;
    String? contact;
    String? alternateContact;
    String? pinNumber;
    dynamic aadharNumber;
    dynamic doorNumber;
    dynamic streetName;
    dynamic area;
    String? fssa;
    dynamic region;
    String? pinYourLocation;
    String? name;
    String? accountNumber;
    String? ifscCode;
    String? upiId;
    String? gpayNumber;
    String? aadhar;
    String? panFile;
    String? profile;
    String? bankPassbook;
    String? gstFile;
    String? date;
    dynamic category;

    FoodAlldata({
        this.businessId,
        this.foodId,
        this.sellerName,
        this.businessName,
        this.panNumber,
        this.gst,
        this.contact,
        this.alternateContact,
        this.pinNumber,
        this.aadharNumber,
        this.doorNumber,
        this.streetName,
        this.area,
        this.fssa,
        this.region,
        this.pinYourLocation,
        this.name,
        this.accountNumber,
        this.ifscCode,
        this.upiId,
        this.gpayNumber,
        this.aadhar,
        this.panFile,
        this.profile,
        this.bankPassbook,
        this.gstFile,
        this.date,
        this.category,
    });

    factory FoodAlldata.fromJson(Map<String, dynamic> json) => FoodAlldata(
        businessId: json["Business_id"],
        foodId: json["food_id"],
        sellerName: json["seller_name"],
        businessName: json["business_name"],
        panNumber: json["pan_number"],
        gst: json["gst"],
        contact: json["contact"],
        alternateContact: json["alternate_contact"],
        pinNumber: json["pin_number"],
        aadharNumber: json["aadhar_number"],
        doorNumber: json["door_number"],
        streetName: json["street_name"],
        area: json["area"],
        fssa: json["fssa"],
        region: json["region"],
        pinYourLocation: json["pin_your_location"],
        name: json["name"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        upiId: json["upi_id"],
        gpayNumber: json["gpay_number"],
        aadhar: json["aadhar"],
        panFile: json["pan_file"],
        profile: json["profile"],
        bankPassbook: json["bank_passbook"],
        gstFile: json["gst_file"],
        date: json["date"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "Business_id": businessId,
        "food_id": foodId,
        "seller_name": sellerName,
        "business_name": businessName,
        "pan_number": panNumber,
        "gst": gst,
        "contact": contact,
        "alternate_contact": alternateContact,
        "pin_number": pinNumber,
        "aadhar_number": aadharNumber,
        "door_number": doorNumber,
        "street_name": streetName,
        "area": area,
        "fssa": fssa,
        "region": region,
        "pin_your_location": pinYourLocation,
        "name": name,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "upi_id": upiId,
        "gpay_number": gpayNumber,
        "aadhar": aadhar,
        "pan_file": panFile,
        "profile": profile,
        "bank_passbook": bankPassbook,
        "gst_file": gstFile,
        "date": date,
        "category": category,
    };
}
