import 'package:flutter/material.dart';

Widget orderSummery(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                width: 3.0,
                color: Colors.green,
              ),
            ),
            child: const Center(
              child: Text(
                '1',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            color: Colors.greenAccent,
            height: 3,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                width: 3.0,
                color: const Color.fromARGB(255, 170, 170, 170),
              ),
            ),
            child: const Center(
              child: Text(
                '2',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(right: 22),
              child: Text(
                'Payment',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Widget orderQty(BuildContext context) {
  return Container();
}

Widget orderSummery1(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(50.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: const EdgeInsets.only(left: 30),
              // height: MediaQuery.of(context).size.height*0.17,
              // width: MediaQuery.of(context).size.width*0.17,
              decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent,
                  )),
              child: const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(
                    child: Text('1',
                        style: TextStyle(fontSize: 30, color: Colors.white))),
              ),
            ),
            Expanded(
              child: Container(
                width: double.maxFinite,
                color: Colors.green,
                height: 1,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 0.17,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                  )),
              child: const Center(
                  child: Text(
                '2',
                style: TextStyle(fontSize: 30, color: Colors.green),
              )),
            )
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Payment',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ],
    ),
  );
}

Widget paymentMethod(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                  )),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                height: 1,
              ),
            ),
            Container(
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                  )),
              child: const Center(
                child: Text(
                  '2',
                  style: TextStyle(fontSize: 30, color: Colors.green),
                ),
              ),
            )
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '   Order\nSummary',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'Payment',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ],
    ),
  );
}
