import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';

class DOriginalCheckoutPage extends StatelessWidget {
  const DOriginalCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FE),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 150,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.green,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF3E3E3E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 100,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(width: .5, color: Colors.black)),
                        child: const Text(
                          "Change",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF3E3E3E),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                    child: Text(
                      "1st  Floor, Sridattatrayaswamy Temp Complex, Gandhi Nagar , Bangalore , Karnataka ,  560009.",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              height: 150,
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://thefederal.com/file/2023/01/Lead-1-4.jpg"),
                                fit: BoxFit.fill)),
                      )),
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tirunelveli Halwa",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF3E3E3E),
                              )),
                          Row(
                            children: [
                              Text("₹370",
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough)),
                              SizedBox(width: 10),
                              Text(
                                "₹325",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget deliveryAddress() {
  return Container(
    height: 150,
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF3E3E3E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              width: 100,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: .5, color: Colors.black)),
              child: const Text(
                "Change",
                style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF3E3E3E),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Text(
            "1st  Floor, Sridattatrayaswamy Temp Complex, Gandhi Nagar , Bangalore , Karnataka ,  560009.",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}

Widget orderedFoods(BuildContext context,  String name, int actual_price, int discount_price,
    String description, String primaryImage) {
  return Container(
    color: Colors.white,
    height: 150,
    // width: double.maxFinite,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(image: NetworkImage(
                      // "https://thefederal.com/file/2023/01/Lead-1-4.jpg",
                      primaryImage,
                      // "http://192.168.1.6:8000//media/api/food_products/7B2095FITE0/primary_image/burger.jpg", 
                      
                      ), fit: BoxFit.fill)),
            )),
            // Text(primaryImage),
        Expanded(
          flex: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    // "Tirunelveli Halwa",
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge
                    
                    // TextStyle(
                    //   fontSize: 18,
                    //   color: Color(0xFF3E3E3E),
                    // )
                    
                    
                    ),
                Row(
                  children: [
                    Text(
                        // "₹370",
                        '₹ $actual_price',
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough)),
                    SizedBox(width: 10),
                    Text(
                      // "₹325",
                      '₹ $discount_price',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Text(
                    // "Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad"
                    description),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
