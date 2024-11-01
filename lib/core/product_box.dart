import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';
// import 'package:miogra/features/dOriginal/presentation/pages/d_original_check_out.dart';

// Square Box With Maximum Details
Widget productBox({
  required imageUrl,
  required String pName,
  required dynamic oldPrice,
  required dynamic newPrice,
  required dynamic offer,
  required dynamic rating,
  required Color color,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),

      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),

                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // width: double.infinity,
                  decoration: BoxDecoration(

                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          pName,
                          style: const TextStyle(
                            color: Color(0xCC434343),
                            fontSize: 17,
                            // fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "\u20B9$oldPrice",
                              maxFontSize: 200,
                              minFontSize: 0,
                              presetFontSizes: const [10],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1.8,
                                // fontSize: 14,
                              ),
                            ),
                            AutoSizeText(
                              "\u20B9$newPrice",
                              maxFontSize: 200,
                              minFontSize: 0,
                              presetFontSizes: const [10],
                              style: const TextStyle(
                                  color: Color(0xff870081),
                                  // fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 2, vertical: 1.5),
                              decoration: const BoxDecoration(
                                  color: Color(0xff0D7824),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3))),
                              child: AutoSizeText(
                                "$offer% OFF",
                                maxFontSize: 200,
                                minFontSize: 0,
                                presetFontSizes: const [10, 15],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    // fontSize: 11,
                                    wordSpacing: .5),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: const Alignment(.87, -.9),
            child: Container(
              padding: const EdgeInsets.only(
                left: 3,
                right: 1,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff870081),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: .5,
                  ),
                  const Icon(Icons.star, size: 13, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget rectangleBox(String path, String pName, int oldPrice, int newPrice,
    void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xE6434343), blurRadius: .5),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    pName,
                    style: const TextStyle(fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 3,
                      right: 1,
                    ),
                    decoration: const BoxDecoration(
                        color: Color(0xff870081),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "4.3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: .5,
                        ),
                        Icon(Icons.star, size: 13, color: Colors.white),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\u20B9$newPrice",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff870081),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "\u20B9$oldPrice",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 1.8,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
// Square Box With Minimum Details

Widget basicSquareBoxOne(String path, String pName, void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
          // border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xE6434343), blurRadius: .5),
          ]),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                  style: BorderStyle.solid,
                  width: .3,
                  color: Colors.black45,
                )),
              ),
              child: Text(
                pName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff434343)),
              ),
            ),
          )
        ],
      ),
    ),
  );
}




Widget basicSquareNetImageBox(String path, String pName, void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
          // border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xE6434343), blurRadius: .5),
          ]),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(path),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                  style: BorderStyle.solid,
                  width: .3,
                  color: Colors.black45,
                )),
              ),
              child: Text(
                pName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff434343)),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget basicSquareBoxTwo(
  String path,
  String pName,
  int price,
  void Function() page,
) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0xE6434343), blurRadius: .5),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/rings.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(top: 5, left: 3, right: 3),
              child: Text(
                pName,
                style: const TextStyle(
                    fontSize: 13.9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff434343)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                "\u20B9$price",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff870081),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget restaurantView(String path, String name, String location, int from,
    int to, double ratings) {
  return Container(
    width: double.infinity,
    height: 165,
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black26, width: .5)),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: AssetImage(path),
                image: NetworkImage(path),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 5),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                name,
                                maxLines: 2,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xE6434343)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 1,
                                ),
                                decoration: const BoxDecoration(
                                    color: Color(0xff870081),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "$ratings",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: .5,
                                    ),
                                    const Icon(Icons.star,
                                        size: 13, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text.rich(
                          TextSpan(children: [
                            const TextSpan(
                                text: 'Delivery within ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            TextSpan(
                              text: '${from}min',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(
                                text: ' to',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: ' ${to}min',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500))
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget rectangleBoxWithoutRatings(String path, String pName, int oldPrice,
    int newPrice, void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xE6434343), blurRadius: .5),
          ]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    pName,
                    style: const TextStyle(fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\u20B9$newPrice",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff870081),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "\u20B9$oldPrice",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 1.8,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget productWithCounter() {
  return Container(
    width: 100,
    height: 100,
    padding: const EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      border: Border.all(
        width: .5,
        color: Colors.black26,
      ),
      color: Colors.white,
    ),
    child: Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage("assets/images/appliances.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Fresh Chicken Breast Boneless",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xE6434343)),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹2500",
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₹1250",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff870081)),
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff870081),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: const Text(
                            "-",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 35,
                        alignment: Alignment.center,
                        child: const Text(
                          "0",
                          style: TextStyle(
                              color: Color(0xff870081),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff870081),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )),
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: const Text(
                            "+",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget rectangleBoxWithoutRatingWithQuantity(String path, String pName,
    String quantity, int oldPrice, int newPrice, void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0xE6434343), blurRadius: .5),
          ]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    pName,
                    style: const TextStyle(fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    quantity,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\u20B9$newPrice",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xff870081),
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "\u20B9$oldPrice",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 1.8,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget productWithCounterWithRatings(
  String path,
  String pName,
  int oldPrice,
  double newPrice,
  int offer, {
  BuildContext? context,
}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      border: Border.all(
        width: .5,
        color: Colors.black26,
      ),
      color: Colors.white,
    ),
    child: Column(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  pName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "₹$oldPrice",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₹$newPrice",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      decoration: const BoxDecoration(
                          color: Color(0xff0D7824),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Text(
                        "$offer% OFF",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            wordSpacing: .5),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff870081)),
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        // onTap: () {},
                        onTap: () {},
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff870081),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: const Text(
                            "-",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 35,
                        alignment: Alignment.center,
                        child: const Text(
                          "0",
                          // qty.toString(),
                          style: TextStyle(
                              color: Color(0xff870081),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // if (context != null){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => const DOriginalCheckoutPage()));
                          // }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff870081),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )),
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: const Text(
                            "+",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget productSharpBox(String path, String pName, String oldPrice,
    String newPrice, int offer, Color color, void Function() page) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 1),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: .3, color: color),
                      image: DecorationImage(
                        image:
                            // AssetImage(path),
                            NetworkImage(path),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15))),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: .3, color: color),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          pName,
                          style: const TextStyle(
                              color: Color(0xCC434343),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\u20B9$oldPrice",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.8,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "\u20B9$newPrice",
                            style: const TextStyle(
                                color: Color(0xff870081),
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 1.5),
                            decoration: const BoxDecoration(
                              color: Color(0xff0D7824),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            child: Text(
                              "$offer% OFF",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  wordSpacing: .5),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: const Alignment(.87, -.9),
            child: Container(
              padding: const EdgeInsets.only(
                left: 3,
                right: 1,
              ),
              decoration: const BoxDecoration(
                  color: Color(0xff870081),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "4.3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: .5,
                  ),
                  Icon(Icons.star, size: 13, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget foodItemBox() {
  return Container(
    padding: const EdgeInsets.only(top: 7),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/appliances.jpeg'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff870081),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              "-",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff870081))),
                          child: const Text(
                            '1',
                            style: TextStyle(
                                color: Color(0xff870081),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff870081),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                )),
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              "+",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          flex: 3,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chiken Manchurian",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 19,
                          color: Color(0xE6434343),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹150",
                        style:
                            TextStyle(fontSize: 19, color: Color(0xE6434343)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 15, color: Color(0xE6434343)),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget dailyMioItemBox(
  String imagePath,
  String name,
  String price,
) {
  return Container(
    padding: const EdgeInsets.only(top: 7),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            child: Column(
              children: [
                Expanded(
                  // flex: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          // 'assets/images/appliances.jpeg'
                          imagePath,
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // "Milma 1/2 litre Pack",
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          color: Color(0xE6434343),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        // "₹40",
                        price,
                        style: const TextStyle(
                            fontSize: 19, color: Color(0xE6434343)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Color(0xff870081),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                "Got Once",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Color(0xff870081),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                "Subscribe",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget usedProductBox({
  required String image,
  required String pName,
  required String price,
  required Color color,
  required String contact,
  required String location,
  required void Function() page,
}) {
  return InkWell(
    onTap: page,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: color, blurRadius: .5),
          ]),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border.all(width: .3, color: color),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: .3, color: color),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      pName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xCC434343),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Text(
                    "\u20B9$price",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact : $contact",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Location : $location")],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
