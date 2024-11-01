// cartlist

// To parse this JSON data, do
//
//     final cartlist = cartlistFromJson(jsonString);

import 'dart:convert';

List<Cartlist> cartlistFromJson(String str) => List<Cartlist>.from(json.decode(str).map((x) => Cartlist.fromJson(x)));

String cartlistToJson(List<Cartlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cartlist {
    String cartId;
    dynamic shopProduct;
    dynamic jewelProduct;
    dynamic dOriginProduct;
    dynamic dailymioProduct;
    dynamic pharmacyProduct;
    FoodProduct foodProduct;
    dynamic freshcutProduct;
    User user;
    DateTime createdDate;
    String quantity;
    int total;
    String category;
    String status;

    Cartlist({
        required this.cartId,
        required this.shopProduct,
        required this.jewelProduct,
        required this.dOriginProduct,
        required this.dailymioProduct,
        required this.pharmacyProduct,
        required this.foodProduct,
        required this.freshcutProduct,
        required this.user,
        required this.createdDate,
        required this.quantity,
        required this.total,
        required this.category,
        required this.status,
    });

    factory Cartlist.fromJson(Map<String, dynamic> json) => Cartlist(
        cartId: json["cart_id"],
        shopProduct: json["shop_product"],
        jewelProduct: json["jewel_product"],
        dOriginProduct: json["d_origin_product"],
        dailymioProduct: json["dailymio_product"],
        pharmacyProduct: json["pharmacy_product"],
        foodProduct: FoodProduct.fromJson(json["food_product"]),
        freshcutProduct: json["freshcut_product"],
        user: User.fromJson(json["user"]),
        createdDate: DateTime.parse(json["created_date"]),
        quantity: json["quantity"],
        total: json["total"],
        category: json["category"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "shop_product": shopProduct,
        "jewel_product": jewelProduct,
        "d_origin_product": dOriginProduct,
        "dailymio_product": dailymioProduct,
        "pharmacy_product": pharmacyProduct,
        "food_product": foodProduct.toJson(),
        "freshcut_product": freshcutProduct,
        "user": user.toJson(),
        "created_date": createdDate.toIso8601String(),
        "quantity": quantity,
        "total": total,
        "category": category,
        "status": status,
    };
}

class FoodProduct {
    String productId;
    String foodId;
    String status;
    String category;
    String subcategory;
    Product product;

    FoodProduct({
        required this.productId,
        required this.foodId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
    });

    factory FoodProduct.fromJson(Map<String, dynamic> json) => FoodProduct(
        productId: json["product_id"],
        foodId: json["food_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "food_id": foodId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product.toJson(),
    };
}

class Product {
    List<String> name;
    List<String> brand;
    List<String> actualPrice;
    List<String> discountPrice;
    List<String> status;
    List<String> category;
    List<String> subcategory;
    String foodId;
    String productId;
    String primaryImage;
    List<String> otherImages;
    double sellingPrice;

    Product({
        required this.name,
        required this.brand,
        required this.actualPrice,
        required this.discountPrice,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.foodId,
        required this.productId,
        required this.primaryImage,
        required this.otherImages,
        required this.sellingPrice,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: List<String>.from(json["name"].map((x) => x)),
        brand: List<String>.from(json["brand"].map((x) => x)),
        actualPrice: List<String>.from(json["actual_price"].map((x) => x)),
        discountPrice: List<String>.from(json["discount_price"].map((x) => x)),
        status: List<String>.from(json["status"].map((x) => x)),
        category: List<String>.from(json["category"].map((x) => x)),
        subcategory: List<String>.from(json["subcategory"].map((x) => x)),
        foodId: json["food_id"],
        productId: json["product_id"],
        primaryImage: json["primary_image"],
        otherImages: List<String>.from(json["other_images"].map((x) => x)),
        sellingPrice: json["selling_price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": List<dynamic>.from(name.map((x) => x)),
        "brand": List<dynamic>.from(brand.map((x) => x)),
        "actual_price": List<dynamic>.from(actualPrice.map((x) => x)),
        "discount_price": List<dynamic>.from(discountPrice.map((x) => x)),
        "status": List<dynamic>.from(status.map((x) => x)),
        "category": List<dynamic>.from(category.map((x) => x)),
        "subcategory": List<dynamic>.from(subcategory.map((x) => x)),
        "food_id": foodId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": List<dynamic>.from(otherImages.map((x) => x)),
        "selling_price": sellingPrice,
    };
}

class User {
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
    // AddressData addressData;
    dynamic tempAddress;

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
        required this.latitude,
        required this.longitude,
        // required this.addressData,
        required this.tempAddress,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
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
        // addressData: AddressData.fromJson(json["address_data"]),
        // addressData: AddressData.fromJson(json["address_data"]),
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
        // "address_data": addressData.toJson(),
        "temp_address": tempAddress,
    };
}

class AddressData {
    String doorno;
    String area;
    String landmark;
    String place;
    String district;
    String state;
    String pincode;

    AddressData({
        required this.doorno,
        required this.area,
        required this.landmark,
        required this.place,
        required this.district,
        required this.state,
        required this.pincode,
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
