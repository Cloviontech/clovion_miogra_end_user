import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../pages/order_track.dart';

Widget orderList( BuildContext context) {
  return  Expanded(
    child: ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderTrackPage()));
          },
          child: Container(
            height: 160,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  )
                ]
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 109,
                    width: 70,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/animal-before.webp'),
                          // fit: BoxFit.fill,
                        )
                    ),
                  ),),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            const Text('Trendy Women Dress',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600),),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,size: 23,)),]),
                      const Text('Delivery by 22/05/2024',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.greenAccent),),
                      IconButton(onPressed: (){
                      }, icon: const Icon(Icons.star_border)),
                      GestureDetector(
                          onTap: (){
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height:MediaQuery.of(context).size.height*0.4,
                                    child:  Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context).size.height*0.2,
                                            width: MediaQuery.of(context).size.width*0.8,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black45
                                                )
                                            ),
                                            child:TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                decoration: const InputDecoration(
                                                  hintText: 'Post Your Review',
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                  border: InputBorder.none,
                                                )
                                            ),
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                                          ElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(170, 40),
                                                backgroundColor: Colors.purple,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ), child: const Text('Submit ',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white70),))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          child: const Text('Post Your Review',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.purple),)),
                    ],
                  ),),
              ],
            ),
          ),
        );
      },
    ),
  );
}