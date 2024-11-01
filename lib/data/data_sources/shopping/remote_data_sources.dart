import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miogra/core/api_services.dart';
import 'package:miogra/data/models/shopping/mobile_models.dart';



abstract class MobileRemoteDataSource {
  Future<List<MobileModel>> getMobileDataFromApi();
}

class MobileRemoteDataSourceImpl implements MobileRemoteDataSource {
  final client = http.Client();
  @override
  Future<List<MobileModel>> getMobileDataFromApi() async {
    // Future<dynamic> getPostFromApi() async{

    try {
      final response = await client.get(
          Uri.parse('https://${ApiServices.ipAddress}/category_based_shop/mobile/'),
          headers: {'content-type': 'application/json'});


          print(response.statusCode);

      if (response.statusCode == 200) {

        print(response);


        final List<dynamic> responsebody = jsonDecode(response.body);

        final List<MobileModel> mobilesData =
            responsebody.map((json) => MobileModel.fromJson(json)).toList();

        return mobilesData;
      } else {

       

        throw Exception("Failed to Load Data");
      }
    } catch (e) {
     

      throw Exception("Failed to Load Data");
    }
  }
  

}
