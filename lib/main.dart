import 'package:flutter/material.dart';
import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/food/controller/food_data.dart';

import 'package:miogra/features/food/presentation/pages/products_selected.dart';

import 'package:miogra/home_page/home_page_trail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var logined = prefs.getString("api_response");

  await PersistentShoppingCart().init();

  runApp(
    MyApp(logined: logined),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.logined});
  final String? logined;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider<Shop>(
          create: (_) => Shop(),
        ),
        ChangeNotifierProvider<Fooddata>(
          create: (_) => Fooddata(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // appBarTheme: AppBarTheme(elevation: 5),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // theme: AppTheme.lightTheme,
        // home: const ProductDetails(),

        //  home: const YourWidget(),

         home: logined == null ?  SignInPage() : HomePage(),

       // home: const AddAddressPage(
       //   edit: true,
        //  food: false,
       //   userId: 'tyfshasgah',
      //  ),
        // home: const HomePage(),
        // home: const TempFreshcutsProducts(
        //   categoryName: 'fresh_cuts',
        //   subCategoryName: 'chicken',
        // ),

        // home: const SignInPage(),

        // home: const CategoryPage(
        //   category: 'helllo',
        //   subCategory: 'its good',
        // ),

        // home: const ChooseAddress(),
      ),
    );
  }
}

