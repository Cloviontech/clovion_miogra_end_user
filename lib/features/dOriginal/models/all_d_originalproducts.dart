// all_d_originalproducts


// To parse this JSON data, do
//
//     final allDOriginalproducts = allDOriginalproductsFromJson(jsonString);

import 'dart:convert';

List<AllDOriginalproducts> allDOriginalproductsFromJson(String str) => List<AllDOriginalproducts>.from(json.decode(str).map((x) => AllDOriginalproducts.fromJson(x)));

String allDOriginalproductsToJson(List<AllDOriginalproducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllDOriginalproducts {
    String productId;
    String dId;
    String status;
    String category;
    String subcategory;
    Product product;
    String district;
    dynamic businessStatus;

    AllDOriginalproducts({
        required this.productId,
        required this.dId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
        required this.district,
        required this.businessStatus,
    });

    factory AllDOriginalproducts.fromJson(Map<String, dynamic> json) => AllDOriginalproducts(
        productId: json["product_id"],
        dId: json["d_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: Product.fromJson(json["product"]),
        district: json["district"],
        businessStatus: json["business_status"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "d_id": dId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product.toJson(),
        "district": district,
        "business_status": businessStatus,
    };
}

class Product {
    List<String> name;
    List<String> brand;
    List<String> actualPrice;
    List<String> discountPrice;
    List<String>? status;
    List<String> category;
    List<String> subcategory;
    String dId;
    String productId;
    String primaryImage;
    List<String> otherImages;
    double sellingPrice;
    List<String>? district;

    Product({
        required this.name,
        required this.brand,
        required this.actualPrice,
        required this.discountPrice,
        this.status,
        required this.category,
        required this.subcategory,
        required this.dId,
        required this.productId,
        required this.primaryImage,
        required this.otherImages,
        required this.sellingPrice,
        this.district,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: List<String>.from(json["name"].map((x) => x)),
        brand: List<String>.from(json["brand"].map((x) => x)),
        actualPrice: List<String>.from(json["actual_price"].map((x) => x)),
        discountPrice: List<String>.from(json["discount_price"].map((x) => x)),
        status: json["status"] == null ? [] : List<String>.from(json["status"]!.map((x) => x)),
        category: List<String>.from(json["category"].map((x) => x)),
        subcategory: List<String>.from(json["subcategory"].map((x) => x)),
        dId: json["d_id"],
        productId: json["product_id"],
        primaryImage: json["primary_image"],
        otherImages: List<String>.from(json["other_images"].map((x) => x)),
        sellingPrice: json["selling_price"]?.toDouble(),
        district: json["district"] == null ? [] : List<String>.from(json["district"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": List<dynamic>.from(name.map((x) => x)),
        "brand": List<dynamic>.from(brand.map((x) => x)),
        "actual_price": List<dynamic>.from(actualPrice.map((x) => x)),
        "discount_price": List<dynamic>.from(discountPrice.map((x) => x)),
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "category": List<dynamic>.from(category.map((x) => x)),
        "subcategory": List<dynamic>.from(subcategory.map((x) => x)),
        "d_id": dId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": List<dynamic>.from(otherImages.map((x) => x)),
        "selling_price": sellingPrice,
        "district": district == null ? [] : List<dynamic>.from(district!.map((x) => x)),
    };
}
