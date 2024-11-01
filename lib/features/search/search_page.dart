import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/features/shopping/presentation/pages/product_details.dart';

import '../../core/product_box.dart';
class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _allItems = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape'];
  List<String> _filteredItems = [];
  Future<dynamic> fetchAllShopProducts() async {
    // String url = 'https://miogra.com/category_based_shop/mobiles';
    String url = 'https://miogra.clovion.org/search_query/${_searchController.text}/';
    try {
      final response = await http.get(Uri.parse(url));

      // log(response.statusCode.toString());

      if (response.statusCode == 200) {
        log('Featching Data');
        final data = json.decode(response.body);

        if (data is List) {
          final jsonData = data;

          log('Data fetched successfully');

          return jsonData;
        } else {
          log('Unexpected data structure: ${data.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load data from URL: $url (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search For Products',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back),color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterItems,
              ),
            ),
            FutureBuilder<dynamic>(
              future: fetchAllShopProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Search For Products',
                    ),
                  );
                } else {
                  final data = snapshot.data;
                  int dataLength = 0;
        
                  if (data != null) {
                    if (data is List) {
                      dataLength = data.length;
                    } else {
                      log('Data is not a list');
                    }
                  } else {
                    log('Data is null');
                  }
        
                  if (data != null && data is List && data.isNotEmpty) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      itemCount: dataLength,
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2,
                        childAspectRatio: .85,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = data[index]
                        ['primary_image']
                            ?.toString();
                        final productName = data[index]
                        ['model_name']
                            .toString()
                            .toUpperCase();
                        final discountPrice =
                        data[index]['selling_price'];
                        final actualprice =
                        data[index]['actual_price'];
                        final rating = data[index]['rating'] ?? 0.0;
        
                        // final subcategory = data[index]['product']['subcategory'];
                        final productid = data[index]['product_id'];
                        final shopeid = data[index]['shop_id'];
                        final category = data[index]['category'];
        
                        return productBox(
                          imageUrl: imageUrl,
                          pName: productName,
                          oldPrice: actualprice,
                          newPrice: discountPrice,
                          rating: rating,
                          offer: 28,
                          color: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productId: productid,
                                  shopeid: shopeid,
                                  category: category,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    // Handle the case where data is null//
                    return const Scaffold(
                      body: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
