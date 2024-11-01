// // To parse this JSON data, do
// //
// //     final foodGetProducts = foodGetProductsFromJson(jsonString);

// import 'dart:convert';

// List<FoodGetProducts> foodGetProductsFromJson(String str) => List<FoodGetProducts>.from(json.decode(str).map((x) => FoodGetProducts.fromJson(x)));

// String foodGetProductsToJson(List<FoodGetProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class FoodGetProducts {
//     String? productId;
//     String? foodId;
//     String? status;
//     String? category;
//     String? subcategory;
//     Product? product;

//     FoodGetProducts({
//         this.productId,
//         this.foodId,
//         this.status,
//         this.category,
//         this.subcategory,
//         this.product,
//     });

//     factory FoodGetProducts.fromJson(Map<String, dynamic> json) => FoodGetProducts(
//         productId: json["product_id"],
//         foodId: json["food_id"],
//         status: json["status"],
//         category: json["category"],
//         subcategory: json["subcategory"],
//         product: json["product"] == null ? null : Product.fromJson(json["product"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "product_id": productId,
//         "food_id": foodId,
//         "status": status,
//         "category": category,
//         "subcategory": subcategory,
//         "product": product?.toJson(),
//     };
// }

// class Product {
//     List<String>? name;
//     List<String>? brand;
//     List<String>? actualPrice;
//     List<String>? discountPrice;
//     List<String>? status;
//     List<String>? category;
//     List<String>? subcategory;
//     String? foodId;
//     String? productId;
//     String? primaryImage;
//     List<String>? otherImages;
//     double? sellingPrice;

//     Product({
//         this.name,
//         this.brand,
//         this.actualPrice,
//         this.discountPrice,
//         this.status,
//         this.category,
//         this.subcategory,
//         this.foodId,
//         this.productId,
//         this.primaryImage,
//         this.otherImages,
//         this.sellingPrice,
//     });

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         name: json["name"] == null ? [] : List<String>.from(json["name"]!.map((x) => x)),
//         brand: json["brand"] == null ? [] : List<String>.from(json["brand"]!.map((x) => x)),
//         actualPrice: json["actual_price"] == null ? [] : List<String>.from(json["actual_price"]!.map((x) => x)),
//         discountPrice: json["discount_price"] == null ? [] : List<String>.from(json["discount_price"]!.map((x) => x)),
//         status: json["status"] == null ? [] : List<String>.from(json["status"]!.map((x) => x)),
//         category: json["category"] == null ? [] : List<String>.from(json["category"]!.map((x) => x)),
//         subcategory: json["subcategory"] == null ? [] : List<String>.from(json["subcategory"]!.map((x) => x)),
//         foodId: json["food_id"],
//         productId: json["product_id"],
//         primaryImage: json["primary_image"],
//         otherImages: json["other_images"] == null ? [] : List<String>.from(json["other_images"]!.map((x) => x)),
//         sellingPrice: json["selling_price"]?.toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
//         "brand": brand == null ? [] : List<dynamic>.from(brand!.map((x) => x)),
//         "actual_price": actualPrice == null ? [] : List<dynamic>.from(actualPrice!.map((x) => x)),
//         "discount_price": discountPrice == null ? [] : List<dynamic>.from(discountPrice!.map((x) => x)),
//         "status": status == null ? [] : List<dynamic>.from(status!.map((x) => x)),
//         "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
//         "subcategory": subcategory == null ? [] : List<dynamic>.from(subcategory!.map((x) => x)),
//         "food_id": foodId,
//         "product_id": productId,
//         "primary_image": primaryImage,
//         "other_images": otherImages == null ? [] : List<dynamic>.from(otherImages!.map((x) => x)),
//         "selling_price": sellingPrice,
//     };
// }



// To parse this JSON data, do
//
//     final foodGetProducts = foodGetProductsFromJson(jsonString);

import 'dart:convert';

List<FoodGetProducts> foodGetProductsFromJson(String str) => List<FoodGetProducts>.from(json.decode(str).map((x) => FoodGetProducts.fromJson(x)));

String foodGetProductsToJson(List<FoodGetProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodGetProducts {
    String productId;
    String foodId;
    String status;
    String category;
    String subcategory;
    Product product;

    FoodGetProducts({
        required this.productId,
        required this.foodId,
        required this.status,
        required this.category,
        required this.subcategory,
        required this.product,
    });

    factory FoodGetProducts.fromJson(Map<String, dynamic> json) => FoodGetProducts(
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
