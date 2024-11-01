// all_dmioproducts



// To parse this JSON data, do
//
//     final allDmioproducts = allDmioproductsFromJson(jsonString);

import 'dart:convert';

List<AllDmioproducts> allDmioproductsFromJson(String str) => List<AllDmioproducts>.from(json.decode(str).map((x) => AllDmioproducts.fromJson(x)));

String allDmioproductsToJson(List<AllDmioproducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllDmioproducts {
    String productId;
    String dmioId;
    String status;
    String category;
    String subcategory;
    Product product;
    dynamic businessStatus;

    AllDmioproducts({
        required this.productId,
        required this.dmioId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
        required this.businessStatus,
    });

    factory AllDmioproducts.fromJson(Map<String, dynamic> json) => AllDmioproducts(
        productId: json["product_id"],
        dmioId: json["dmio_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: Product.fromJson(json["product"]),
        businessStatus: json["business_status"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "dmio_id": dmioId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product.toJson(),
        "business_status": businessStatus,
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
    String dmioId;
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
        required this.dmioId,
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
        dmioId: json["dmio_id"],
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
        "dmio_id": dmioId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": List<dynamic>.from(otherImages.map((x) => x)),
        "selling_price": sellingPrice,
    };
}
