import 'package:flutter/material.dart';
import 'package:miogra/features/shopping/presentation/pages/your_order.dart';

import '../widgets/address_display_widget.dart';
import 'order_track.dart';
const List<String> list = <String>['Qty:1', 'Qty:2', 'Qty:3'];
class QtyPage extends StatefulWidget {
  const QtyPage({super.key});

  @override
  State<QtyPage> createState() => _QtyPageState();
}

class _QtyPageState extends State<QtyPage> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderTrackPage()));
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
      ),
      bottomNavigationBar:
      Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.07,
              child: const Center(child: Text('₹ 5,677',style: TextStyle(color: Colors.black,fontSize: 24),)),
            )
          ),
          Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height*0.07,
                color: Colors.purple,
                child: const Center(child: Text('Continue',style: TextStyle(color: Colors.white,fontSize: 24),)),
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const YourOrderPage()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.23,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.2,
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/woman-5828786_1280.jpg'),
                                  )
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Text('Trendy Women\'s Jacket',style: TextStyle(fontSize: 14),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text('767',style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w300),),
                                      const Text('676',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                      Container(
                                        color: Colors.greenAccent,
                                        height: MediaQuery.of(context).size.height*0.03,
                                        width: MediaQuery.of(context).size.width*0.15,
                                        child: const Center(child: Text('30% Off',style: TextStyle(color: Colors.white),)),
                                      )
                                    ],
                                  ),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Size  :  S ,',style: TextStyle(fontSize: 14),),
                                      Text('Color  : Blue',style: TextStyle(fontSize: 14),),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(left:7),
                                      height: MediaQuery.of(context).size.height*0.055,
                                      width: MediaQuery.of(context).size.width*0.2,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey
                                          )
                                      ),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),
                                          underline: Container(
                                            height: 0,
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropdownValue = value!;
                                            });
                                          },
                                          items: list.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.19,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width*0.17,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.purple
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('4.3',style: TextStyle(color: Colors.white),),
                                        Icon(Icons.star,color: Colors.white,size: 20,),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(onPressed: (){}, icon: const Icon(Icons.delete,color: Colors.grey,)),
                                      const Text('Remove',style: TextStyle(color: Colors.grey),),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }
            ),
            address(context),

          ],
        ),
      ),
    );
  }
}
