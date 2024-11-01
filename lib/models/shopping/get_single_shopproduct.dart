// To parse this JSON data, do
//
//     final getSingleShopproduct = getSingleShopproductFromJson(jsonString);

import 'dart:convert';

List<GetSingleShopproduct> getSingleShopproductFromJson(String str) => List<GetSingleShopproduct>.from(json.decode(str).map((x) => GetSingleShopproduct.fromJson(x)));

String getSingleShopproductToJson(List<GetSingleShopproduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSingleShopproduct {
    String? productId;
    String? shopId;
    String? status;
    String? category;
    String? subcategory;
    Product? product;

    GetSingleShopproduct({
        this.productId,
        this.shopId,
        this.status,
        this.category,
        this.subcategory,
        this.product,
    });

    factory GetSingleShopproduct.fromJson(Map<String, dynamic> json) => GetSingleShopproduct(
        productId: json["product_id"],
        shopId: json["shop_id"],
        status: json["status"],
        category: json["category"],
        subcategory: json["subcategory"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "shop_id": shopId,
        "status": status,
        "category": category,
        "subcategory": subcategory,
        "product": product?.toJson(),
    };
}

class Product {
    List<String>? name;
    List<String>? brand;
    List<String>? actualPrice;
    List<String>? discountPrice;
    List<String>? status;
    List<String>? category;
    List<String>? subcategory;
    String? shopId;
    String? productId;
    String? primaryImage;
    List<String>? otherImages;
    double? sellingPrice;

    Product({
        this.name,
        this.brand,
        this.actualPrice,
        this.discountPrice,
        this.status,
        this.category,
        this.subcategory,
        this.shopId,
        this.productId,
        this.primaryImage,
        this.otherImages,
        this.sellingPrice,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
        brand: json["brand"] == null ? [] : List<String>.from(json["brand"]!.map((x) => x)),
        actualPrice: json["actual_price"] == null ? [] : List<String>.from(json["actual_price"]!.map((x) => x)),
        discountPrice: json["discount_price"] == null ? [] : List<String>.from(json["discount_price"]!.map((x) => x)),
        status: json["status"] == null ? [] : List<String>.from(json["status"]!.map((x) => x)),
        category: json["category"] == null ? [] : List<String>.from(json["category"]!.map((x) => x)),
        subcategory: json["subcategory"] == null ? [] : List<String>.from(json["subcategory"]!.map((x) => x)),
        shopId: json["shop_id"],
        productId: json["product_id"],
        primaryImage: json["primary_image"],
        otherImages: json["other_images"] == null ? [] : List<String>.from(json["other_images"]!.map((x) => x)),
        sellingPrice: json["selling_price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "brand": brand == null ? [] : List<dynamic>.from(brand!.map((x) => x)),
        "actual_price": actualPrice == null ? [] : List<dynamic>.from(actualPrice!.map((x) => x)),
        "discount_price": discountPrice == null ? [] : List<dynamic>.from(discountPrice!.map((x) => x)),
        "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
        "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
        "subcategory": subcategory == null ? [] : List<dynamic>.from(subcategory!.map((x) => x)),
        "shop_id": shopId,
        "product_id": productId,
        "primary_image": primaryImage,
        "other_images": otherImages == null ? [] : List<dynamic>.from(otherImages!.map((x) => x)),
        "selling_price": sellingPrice,
    };
}
