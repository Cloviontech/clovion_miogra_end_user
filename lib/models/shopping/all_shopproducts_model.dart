// To parse this JSON data, do
//
//     final allShopproducts = allShopproductsFromJson(jsonString);

import 'dart:convert';

List<AllShopproducts> allShopproductsFromJson(String str) => List<AllShopproducts>.from(json.decode(str).map((x) => AllShopproducts.fromJson(x)));

String allShopproductsToJson(List<AllShopproducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllShopproducts {
    String productId;
    String shopId;
    String status;
    String category;
    String subcategory;
    Product product;

    AllShopproducts({
        required this.productId,
        required this.shopId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
    });

    factory AllShopproducts.fromJson(Map<String, dynamic> json) => AllShopproducts(
        productId: json["product_id"],
        shopId: json["shop_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "shop_id": shopId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product.toJson(),
    };
}

class Product {
    dynamic name;
    dynamic brand;
    dynamic actualPrice;
    dynamic discountPrice;
    dynamic status;
    dynamic category;
    dynamic subcategory;
    String? shopId;
    String? productId;
    String primaryImage;
    dynamic otherImages;
    dynamic sellingPrice;
    List<String>? color;
    List<String>? subcategory1;

    Product({
        required this.name,
        required this.brand,
        required this.actualPrice,
        required this.discountPrice,
        this.status,
        required this.category,
        required this.subcategory,
        this.shopId,
        this.productId,
        required this.primaryImage,
        required this.otherImages,
        required this.sellingPrice,
        this.color,
        this.subcategory1,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        brand: json["brand"],
        actualPrice: json["actual_price"],
        discountPrice: json["discount_price"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        shopId: json["shop_id"],
        productId: json["product_id"],
        primaryImage: json["primary_image"],
        otherImages: json["other_images"],
        sellingPrice: json["selling_price"],
        color: json["color"] == null ? [] : List<String>.from(json["color"]!.map((x) => x)),
        subcategory1: json["subcategory1"] == null ? [] : List<String>.from(json["subcategory1"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "brand": brand,
        "actual_price": actualPrice,
        "discount_price": discountPrice,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "shop_id": shopId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": otherImages,
        "selling_price": sellingPrice,
        "color": color == null ? [] : List<dynamic>.from(color!.map((x) => x)),
        "subcategory1": subcategory1 == null ? [] : List<dynamic>.from(subcategory1!.map((x) => x)),
    };
}
