import 'package:flutter/material.dart';

class ProductBoxWithCounter extends StatefulWidget {
  const ProductBoxWithCounter({super.key, required this.path, required this.pName, required this.oldPrice, required this.newPrice, required this.offer, required this.qty, required this.qtyInc, required this.qtyDec, required this.CalcPrice});


   final String path; final String pName; final int oldPrice; final double newPrice;
     final int offer; 
     final int qty;
     final VoidCallback qtyInc;
     final VoidCallback qtyDec;
     final VoidCallback CalcPrice;
     
     
     

  @override
  State<ProductBoxWithCounter> createState() => _ProductBoxWithCounterState();
}

class _ProductBoxWithCounterState extends State<ProductBoxWithCounter> {
  @override
  Widget build(BuildContext context) {
    return  Container(
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
                  image: AssetImage(widget.path),
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
                  widget.pName,
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
                      "₹${widget.oldPrice}",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "₹${widget.newPrice}",
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
                        "${widget. offer}% OFF",
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
                        onTap: () {
                          widget.qtyDec;
                          widget.CalcPrice;
                         

                        },
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
                        child:  Text(
                          // "0",
                         widget. qty.toString(),
                          style: TextStyle(
                              color: Color(0xff870081),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      InkWell(
                        onTap: () {

                          widget.qtyInc;
                          widget.CalcPrice;

                         
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
}