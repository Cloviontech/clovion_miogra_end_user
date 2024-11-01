import 'dart:convert';

class CategoryBasedFood {
  String? productId;
  String? foodId;
  String? status;
  String? category;
  String? subcategory;
  Product? product;
  String? businessStatus;
  dynamic rating;
  int? orderQuantity;

  CategoryBasedFood({
    this.productId,
    this.foodId,
    this.status,
    this.category,
    this.subcategory,
    this.product,
    this.businessStatus,
    this.rating,
    this.orderQuantity,
  });

  factory CategoryBasedFood.fromRawJson(String str) => CategoryBasedFood.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryBasedFood.fromJson(Map<String, dynamic> json) => CategoryBasedFood(
    productId: json["product_id"],
    foodId: json["food_id"],
    status: json["status"],
    category: json["category"],
    subcategory: json["subcategory"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    businessStatus: json["business_status"],
    rating: json["rating"],
    orderQuantity: json["orderQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "food_id": foodId,
    "status": status,
    "category": category,
    "subcategory": subcategory,
    "product": product?.toJson(),
    "business_status": businessStatus,
    "rating": rating,
    "orderQuantity": orderQuantity,
  };
}

class Product {
  String? jsjsjs;
  String? ejdjdj;
  String? category;
  String? subcategory;
  String? brand;
  String? modelName;
  String? productDescription;
  String? noOfStocks;
  String? deliveryType;
  String? actualPrice;
  String? discountPrice;
  String? price;
  String? discount;
  String? gst;
  String? foodId;
  String? productId;
  String? primaryImage;
  int? sellingPrice;
  List<String>? otherImages;

  Product({
    this.jsjsjs,
    this.ejdjdj,
    this.category,
    this.subcategory,
    this.brand,
    this.modelName,
    this.productDescription,
    this.noOfStocks,
    this.deliveryType,
    this.actualPrice,
    this.discountPrice,
    this.price,
    this.discount,
    this.gst,
    this.foodId,
    this.productId,
    this.primaryImage,
    this.sellingPrice,
    this.otherImages,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    jsjsjs: json["jsjsjs"],
    ejdjdj: json["ejdjdj"],
    category: json["category"],
    subcategory: json["subcategory"],
    brand: json["brand"],
    modelName: json["model_name"],
    productDescription: json["product_description"],
    noOfStocks: json["no_of_stocks"],
    deliveryType: json["delivery_type"],
    actualPrice: json["actual_price"],
    discountPrice: json["discount_price"],
    price: json["price"],
    discount: json["discount"],
    gst: json["gst"],
    foodId: json["food_id"],
    productId: json["product_id"],
    primaryImage: json["primary_image"],
    sellingPrice: json["selling_price"],
    otherImages: json["other_images"] == null ? [] : List<String>.from(json["other_images"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
  "jsjsjs": jsjsjs,
  "ejdjdj": ejdjdj,
  "category": category,
  "subcategory": subcategory,
  "brand": brand,
  "model_name": modelName,
  "product_description": productDescription,
  "no_of_stocks": noOfStocks,
  "delivery_type": deliveryType,
  "actual_price": actualPrice,
  "discount_price": discountPrice,
  "price": price,
  "discount": discount,
  "gst": gst,
  "food_id": foodId,
  "product_id": productId,
  "primary_image": primaryImage,
  "selling_price": sellingPrice,
  "other_images": otherImages == null ? [] : List<dynamic>.from(otherImages!.map((x) =>x)),};
}