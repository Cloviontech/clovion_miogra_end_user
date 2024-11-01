



import 'dart:convert';

import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/food/models_foods/food_alldata.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/features/food/models_foods/food_get_products_model.dart';
import 'package:miogra/features/food/models_foods/my_food_data.dart';


// food_alldata

Future<List<FoodAlldata>> fetchFoodAllData() async {
  final response = await http.get(Uri.parse(
      'https://${ApiServices.ipAddress}/food_alldata'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);

    
    return data.map((json) => FoodAlldata.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

