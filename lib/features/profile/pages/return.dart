import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../../core/api_services.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({
    super.key,
    required this.userId,
    required this.orderId,
  });

  final String userId;
  final String orderId;

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

enum SingingCharacter { returnProduct, exchange }

class _ReturnPageState extends State<ReturnPage> {
  SingingCharacter? _character = SingingCharacter.returnProduct;
  bool isChecked = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  TextEditingController reviewsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            )),
        title: const Text(
          'Return',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                )
              ]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: const Text('Return Product'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.returnProduct,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Exchange'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.exchange,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.29,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      'Reason ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: const Text('Defected Product'),
                    leading: Checkbox(
                      activeColor: Colors.purple,
                      checkColor: Colors.white70,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Size Mismatch'),
                    leading: Checkbox(
                      activeColor: Colors.purple,
                      checkColor: Colors.white70,
                      value: isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked2 = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Wrong Product'),
                    leading: Checkbox(
                      activeColor: Colors.purple,
                      checkColor: Colors.white70,
                      value: isChecked3,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked3 = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                  controller: reviewsController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Post Your Review',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                orderReturnRequest();
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  void orderReturnRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("api_response").toString();
    String url =
        'https://${ApiServices.ipAddress}/user_product_order_status_return/$userId/${widget.orderId}';
    log(url);

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully posted data
        log('Order Returned...');

        Navigator.pop(context);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Returned'),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
        // Error occurred while posting data, but it's expected
        log('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }
}
