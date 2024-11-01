import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/jewellery/models/all_jewelproducts_model.dart';
import 'package:miogra/models/freshcuts/single_freshproduct_model.dart';
import 'package:miogra/models/shopping/category_model.dart';
import 'package:miogra/models/shopping/get_single_shopproduct.dart';

Future<List<CategoryBasedShop>> fetchProducts(String product) async {
  final response = await http.get(Uri.parse(
      'https://${ApiServices.ipAddress}/category_based_shop/$product'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => CategoryBasedShop.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}


List < GetSingleShopproduct> getSingleShopproductS = [];

Future<List<GetSingleShopproduct>> fetchSingleShopProducts(String shopId , String productId, String link) async {
  final response = await http.get(Uri.parse(
      // 'http://${ApiServices.ipAddress}/get_single_shopproduct/$shopId/$productId'));
      'https://${ApiServices.ipAddress}/$link/$shopId/$productId'));
      

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    getSingleShopproductS = data.map((dat) => GetSingleShopproduct.fromJson(dat)).toList();

    
    return data.map((json) => GetSingleShopproduct.fromJson(json)).toList();


    

  } else {
    throw Exception('Failed to load products');
  }
}



// "T6YZNIT6LRO", "product_id": "MV7TF27IMAG

Future<List<AllJewelproducts>> fetchSingleJewelProducts(String shopId , String productId, String link) async {
  final response = await http.get(Uri.parse(
      // 'http://${ApiServices.ipAddress}/get_single_shopproduct/$shopId/$productId'));
      'https://${ApiServices.ipAddress}/single_freshproduct/$shopId/$productId'));
      

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    
    return data.map((json) => AllJewelproducts.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
