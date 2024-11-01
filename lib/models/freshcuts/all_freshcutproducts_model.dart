// To parse this JSON data, do
//
//     final allFreshcutproducts = allFreshcutproductsFromJson(jsonString);

import 'dart:convert';

List<AllFreshcutproducts> allFreshcutproductsFromJson(String str) => List<AllFreshcutproducts>.from(json.decode(str).map((x) => AllFreshcutproducts.fromJson(x)));

String allFreshcutproductsToJson(List<AllFreshcutproducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllFreshcutproducts {
    String productId;
    String freshId;
    String status;
    String category;
    String subcategory;
    Product product;
    dynamic businessStatus;

    AllFreshcutproducts({
        required this.productId,
        required this.freshId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
        required this.businessStatus,
    });

    factory AllFreshcutproducts.fromJson(Map<String, dynamic> json) => AllFreshcutproducts(
        productId: json["product_id"],
        freshId: json["fresh_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: Product.fromJson(json["product"]),
        businessStatus: json["business_status"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "fresh_id": freshId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product.toJson(),
        "business_status": businessStatus,
    };
}

class Product {
    List<String>? name;
    dynamic brand;
    dynamic actualPrice;
    dynamic discountPrice;
    List<String>? status;
    dynamic category;
    dynamic subcategory;
    String freshId;
    String productId;
    String primaryImage;
    dynamic otherImages;
    dynamic sellingPrice;
    String? modelName;
    String? productDescription;

    Product({
        this.name,
        required this.brand,
        required this.actualPrice,
        required this.discountPrice,
        this.status,
        required this.category,
        required this.subcategory,
        required this.freshId,
        required this.productId,
        required this.primaryImage,
        required this.otherImages,
        required this.sellingPrice,
        this.modelName,
        this.productDescription,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
        brand: json["brand"],
        actualPrice: json["actual_price"],
        discountPrice: json["discount_price"],
        status: json["status"] == null ? [] : List<String>.from(json["status"]!.map((x) => x)),
        category: json["category"],
        subcategory: json["subcategory"],
        freshId: json["fresh_id"],
        productId: json["product_id"],
        primaryImage: json["primary_image"],
        otherImages: json["other_images"],
        sellingPrice: json["selling_price"]?.toDouble(),
        modelName: json["model_name"],
        productDescription: json["product_description"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "brand": brand,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "category": category,
        "subcategory": subcategory,
        "fresh_id": freshId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": otherImages,
        "selling_price": sellingPrice,
        "model_name": modelName,
        "product_description": productDescription,
    };
}
