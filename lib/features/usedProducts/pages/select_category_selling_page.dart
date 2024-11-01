import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:miogra/core/data.dart';
import 'package:miogra/features/usedProducts/pages/product_upload_page.dart';

class SelectCategoryForSellingScreen extends StatefulWidget {
  const SelectCategoryForSellingScreen({super.key});

  @override
  State<SelectCategoryForSellingScreen> createState() => _SelectCategoryForSellingScreenState();
}

class _SelectCategoryForSellingScreenState extends State<SelectCategoryForSellingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          
          
          children: [
          

          Column(
            children: [
              Container(height: 70 ,color:  Color(0xff870081),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white,),
                     
                      Text('Select Category for selling', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                       SizedBox(width: 10,),],),
                       SizedBox(height: 10,),
                ],
              ),
              
              ),

              
            ],
          ),

          // SizedBox(height: 50,),
         ListView.builder(
          controller: ScrollController(),
          physics: AlwaysScrollableScrollPhysics(),
          
          shrinkWrap: true,
          itemCount: userProductsCategory.length,
          itemBuilder: (context, index){
          return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: GestureDetector(

              onTap: () {

               Navigator.push(context,MaterialPageRoute(builder: (context) =>  UsedProductUpload(category:  userProductsCategory[index]['name']!.toString(),)),);
                
              },
              child: Container(
                       
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(0xfff8dbfe)),
                  alignment: Alignment.center,
                
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    
                    // 'Electronics',
                    userProductsCategory[index]['name']!,
                    
                    
                     style: TextStyle( fontSize: 25),),
                )),
            ),
          );
         }),
          
        ],),
      ),
    );
  }
}