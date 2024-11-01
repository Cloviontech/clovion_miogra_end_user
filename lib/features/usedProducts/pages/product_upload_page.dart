import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/usedProducts/controllers/user_product_form_controllers.dart';
import 'package:miogra/features/usedProducts/widgets/user_products_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsedProductUpload extends StatefulWidget {
  final category;
  const UsedProductUpload({super.key,required this.category});

  @override
  State<UsedProductUpload> createState() => _UsedProductUploadState();
}

class _UsedProductUploadState extends State<UsedProductUpload> {

  TextEditingController  sellingPriceTextEditingController = TextEditingController();
  TextEditingController  ramTextEditingController = TextEditingController();TextEditingController  romTextEditingController = TextEditingController();

  late File _profileImage;

  Future pickFile() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      setState(() {
        _profileImage = File(image!.path);
      });
    } catch (e) {
      log('Image not selected');
    }
  }
  late File _profileImages;

  Future pickFile2() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      setState(() {
        _profileImages = File(image!.path);
      });
    } catch (e) {
      log('Image not selected');
    }
  }

  void uploadProduct(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    log(userId.toString());
    String url = 'https://${ApiServices.ipAddress}/used_products/VY68VQJBMAN';
    log(url);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      // Populate form fields

      request.fields['brand'] = brandController.text.toString();
      // request.fields['phone_number'] = contactController.text;
      request.fields['model_name'] = modelNameController.text.toString();
      request.fields['description'] = productDescriptionController.text.toString();
      request.fields['contact'] = contactController.text.toString();
      request.fields['district'] = districtController.text.toString();
      request.fields['purchase'] = yearAndMonthController.text.toString();
      request.fields['subcategory'] = widget.category.toString();
      request.fields['category'] = "used_products";
      request.fields['ram'] = ramTextEditingController.text;
      request.fields['rom'] = romTextEditingController.text;
     // request.fields['other_images'] = "";

      request.fields['selling_price'] = sellingPriceTextEditingController.text.toString();



    log(_profileImages.path.toString());
      request.files.add(
        http.MultipartFile(
          'other_images',
          _profileImages.readAsBytes().asStream(),
          _profileImages.lengthSync(),
          filename: basename(_profileImages.path),
        ),
      );
      log(_profileImage.path.toString());
    request.files.add(
    http.MultipartFile(
    'primary_image',
    _profileImage.readAsBytes().asStream(),
    _profileImage.lengthSync(),
    filename: basename(_profileImage.path),
    ),
    );

    var response = await request.send();
    String responseBody = await response.stream.bytesToString();
    responseBody = responseBody.trim().replaceAll('"', '');
    log(responseBody.toString());

    if (response.statusCode == 200) {
    // navigateFn(context);
    //  Navigator.pop(context);
    // Navigator.pop(context);
    //  Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    content: Text(
    'Product Added Successfully',
    style: TextStyle(
    color: Colors.white,
    ),
    ),
    ),

    );
Navigator.pop(context);
    String responseBody = await response.stream.bytesToString();
    responseBody = responseBody.trim().replaceAll('"', '');
    } else {
    String responseBody = await response.stream.bytesToString();
    responseBody = responseBody.trim().replaceAll('"', '');

    log('Failed to post data: ${response.statusCode}');
    }
    } catch (e) {
    log('Exception while posting data: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    print(widget.category.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Product Details Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Product Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFf3e3e3e)),
              ),
            ),
            const SizedBox(height: 20),
            const ProductDetailsForm(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickFile();
                    },
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFC4F00),
                              blurRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Color(0xFFFC4F00),
                            size: 35,
                          ),
                          Text(
                            "Primary\nImage",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFC4F00),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 120,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFC4F00),
                              blurRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(

                            onPressed: () {
                              pickFile2();
                            }, icon: Icon( Icons.upload_file,
                            color: Color(0xFFFC4F00),
                            size: 35,),
                          ),
                          Text(
                            "Other\nImages",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFC4F00),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Custom Description",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFf3e3e3e)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        textEditingControllers.add(
                            [  TextEditingController(text: ramTextEditingController.text), TextEditingController(text: romTextEditingController.text)]);
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: Color(0xFFFC4F00),
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Custom Description Form
            SizedBox(
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: textEditingControllers.length,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: textEditingControllers[index][0],
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Title"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: textEditingControllers[index][1],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Value",
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  textEditingControllers.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Pricing Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFf3e3e3e)),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Expanded(child: Center(child: Text("Selling Price"))),
                  Expanded(
                    child: TextField(
                      controller: sellingPriceTextEditingController,
                      decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                uploadProduct(context);
              },
              child: Container(
                height: 60,
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),

            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}

// Product Details Form
class ProductDetailsForm extends StatefulWidget {
  const ProductDetailsForm({super.key});

  @override
  State<ProductDetailsForm> createState() => _ProductDetailsFormState();
}

class _ProductDetailsFormState extends State<ProductDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          productDetailsFormTextField(
              controller: brandController, label: "Brand"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: modelNameController, label: "Model Name"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: productDescriptionController,
              label: "Product Description"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: contactController, label: "Contact"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: districtController, label: "District"),
          const SizedBox(height: 20),
          productDetailsFormTextField(
              controller: yearAndMonthController,
              label: "Year and Month Of Purchase"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
