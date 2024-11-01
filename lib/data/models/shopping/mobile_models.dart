
import 'package:miogra/domain/entities/shopping/entity.dart';

class MobileModel extends MobileEntity {
   MobileModel({
    required product_id, required shop_id, required status, 
    
    required category, required subcategory, required product, 
  }) : super(productId: product_id, shopId: shop_id, status: status,
  
  category: category, subCategory: subcategory, product: product
  );

  factory MobileModel.fromJson(Map<String, dynamic> json) {
    return MobileModel(
        product_id: json['product_id'],
        shop_id: json['shop_id'],
        status: json['status'],
        category: json['category'],
        subcategory: json['subcategory'],
        product: json['product']);
        
  }
}