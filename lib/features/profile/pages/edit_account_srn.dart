// saran
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_services.dart';
import '../../../models/cart/cartlist_model.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path; // Import the path package

class EditAccount extends StatefulWidget {
  const EditAccount({
    super.key,
    this.image,
    required this.email,
    required this.phoneNumber,
    required this.name,
  });

  final String? image;
  final String name;
  final String email;
  final String phoneNumber;

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  //  late Future<List<SingleUsersData>> futureSingleUsersdata;

  List<dynamic> singleUsersData = [];

  late String userId;

  fetchsingleUsersData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString("api_response").toString();

    final response = await http.get(Uri.parse(
        'https://${ApiServices.ipAddress}/single_users_data/$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // return singleUsersData.map((json1) => SingleUsersData.fromJson(json1)).toList();
      setState(() {
        singleUsersData =
            jsonResponse.map((data) => User.fromJson(data)).toList();

        // _isLoading = false;
      });

      log(singleUsersData[0].profilePicture.toString());
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    // singleUsersData = fetchsingleUsersData();
    fetchsingleUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Account',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // widget.image == null
                      //     ?
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.person),
                        ),
                      )
                      // : SquareImage(
                      //     height: 200,
                      //     width: 200,
                      //     title: widget.name,
                      //     // image: singleUsersData[0].profilePicture,
                      //     image: widget.image.toString(),
                      //     // image: '',
                      //   ),
                      // IconButton(
                      //   alignment: Alignment.bottomRight,
                      //   color: Theme.of(context)
                      //       .colorScheme
                      //       .primary
                      //       .withOpacity(0.5),
                      //   onPressed: pickImage,
                      //   icon: const Icon(
                      //     Icons.add,
                      //     size: 50,
                      //   ),
                      // )
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_add_alt_1_outlined),
                  title: Text(widget.name),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //   title: const Text(
                          //     'Edit user name',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          // ),
                          actions: [
                            Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: TextField(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 156, 39, 176),
                                      ),
                                      foregroundColor: WidgetStatePropertyAll(
                                        Color.fromARGB(255, 156, 39, 176),
                                      ),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Submitted',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  tileColor: Colors.white,
                ),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(widget.email),
                  // trailing: Icon(Icons.edit),
                  tileColor: Colors.white,
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(widget.phoneNumber),
                  // trailing: Icon(Icons.edit),
                  tileColor: Colors.white,
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8B1874),
              ),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context){
                //   return const signin();
                // }));

                updatedProfile();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontFamily: 'Actor',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatedProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text('Profile Updated'),
      ),
    );
  }

  // Future<void> pickImage() async {
  //   final imagePicker = ImagePicker();

  //   try {
  //     final XFile? pickedImage = await imagePicker.pickImage(
  //       source: await showDialog(
  //         context: context,
  //         builder: (context) => SimpleDialog(
  //           title: const Text('Choose Image Source'),
  //           children: [
  //             ListTile(
  //               title: const Text('Camera'),
  //               onTap: () => Navigator.pop(context, ImageSource.camera),
  //             ),
  //             ListTile(
  //               title: const Text('Gallery'),
  //               onTap: () => Navigator.pop(context, ImageSource.gallery),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //     showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => Center(
  //         child: WillPopScope(
  //           onWillPop: () {
  //             return Future.value(false);
  //           },
  //           child: const CircularProgressIndicator(
  //             color: Color.fromARGB(255, 156, 39, 176),
  //           ),
  //         ),
  //       ),
  //     );

  //     if (pickedImage != null) {
  //       setState(() {
  //         // imageUrl = ''; // Reset to avoid displaying previous image
  //       });
  //       await uploadImage(File(pickedImage.path));
  //     }
  //     Navigator.pop(context);
  //   } catch (e) {
  //     // log(e.toString());
  //     print('Error Fount');
  //   }
  // }

  // Future<void> uploadImage(File imageFile) async {
  //   // Upload image to Firebase Storage
  //   try {
  //     // final reference = FirebaseStorage.instance
  //     //     .ref()
  //     //     .child('shope_images/${DateTime.now().millisecondsSinceEpoch}');
  //     // await reference.putFile(imageFile);
  //     // final downloadUrl = await reference.getDownloadURL();
  //     setState(() {
  //       // imageUrl = downloadUrl;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error uploading image: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> pickImage() async {
  //   final imagePicker = ImagePicker();

  //   try {
  //     final XFile? pickedImage = await imagePicker.pickImage(
  //       source: await showDialog(
  //         context: context,
  //         builder: (context) => SimpleDialog(
  //           title: const Text('Choose Image Source'),
  //           children: [
  //             ListTile(
  //               title: const Text('Camera'),
  //               onTap: () => Navigator.pop(context, ImageSource.camera),
  //             ),
  //             ListTile(
  //               title: const Text('Gallery'),
  //               onTap: () => Navigator.pop(context, ImageSource.gallery),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );

  //     if (pickedImage != null) {
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => Center(
  //           child: WillPopScope(
  //             onWillPop: () => Future.value(false),
  //             child: const CircularProgressIndicator(
  //               color: Color.fromARGB(255, 156, 39, 176),
  //             ),
  //           ),
  //         ),
  //       );

  //       await uploadImage(File(pickedImage.path));
  //       Navigator.pop(context); // Close progress dialog after upload
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error picking image: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Future<void> uploadImage(File imageFile) async {
  //   // Replace with your Django REST framework API endpoint URL
  //   // final String uploadUrl = 'http://your-api-endpoint/profile/update_picture/';
  //   String uploadUrl =
  //       'http://${ApiServices.ipAddress}/enduser_profile_update/$userId';

  //   try {
  //     // var stream = new https.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  //     var stream = https.ByteStream(imageFile.openRead());
  //     var length = await imageFile.length();
  //     var uri = Uri.parse(uploadUrl);
  //     var request = https.MultipartRequest("POST", uri);

  //     // Add authentication headers if required by your API
  //     // request.headers.addAll({'Authorization': 'Token YOUR_AUTH_TOKEN'}); // Example

  //     // var multipartFile = new https.MultipartFile('profile_picture', stream, length, filename: basename(imageFile.path));
  //     var multipartFile = https.MultipartFile('profile_picture', stream, length,
  //         filename: path.basename(imageFile.path));
  //     request.files.add(multipartFile);
  //     request.files.add(multipartFile);

  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Handle successful upload response
  //       // You can potentially update your UI with the new profile picture URL
  //       // or any other data returned by the API
  //       final responseBody = await response.stream.bytesToString();
  //       var decodedResponse = json.decode(responseBody);
  //       print('Upload successful: $decodedResponse');
  //     } else {
  //       print('Upload failed with status: ${response.statusCode}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Upload failed: ${response.statusCode}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error uploading image: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();

    try {
      final XFile? pickedImage = await imagePicker.pickImage(
        source: await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Choose Image Source'),
            children: [
              ListTile(
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (pickedImage != null) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Center(
            child: WillPopScope(
              onWillPop: () => Future.value(false),
              child: const CircularProgressIndicator(
                color: Color.fromARGB(255, 156, 39, 176),
              ),
            ),
          ),
        );

        await uploadImage(File(pickedImage.path));
        Navigator.pop(context); // Close progress dialog after upload
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> uploadImage(File imageFile) async {
    // final response = await https.get(Uri.parse(
    // 'https://${ApiServices.ipAddress}/single_users_data/$userId'));
    // Replace with your Django REST framework API endpoint URL

    log(userId);

    String uploadUrl =
        'http://${ApiServices.ipAddress}/enduser_profile_update/$userId';

    log(uploadUrl);

    try {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var uri = Uri.parse(uploadUrl);
      var request = http.MultipartRequest("POST", uri);

      // Add authentication headers if required by your API
      // request.headers.addAll({'Authorization': 'Token YOUR_AUTH_TOKEN'}); // Example

      var multipartFile = http.MultipartFile('profile_picture', stream, length,
          filename: path.basename(imageFile.path));
      request.files.add(multipartFile);

      // request.files.add(multipartFile);

      var response = await request.send();

      log(response.reasonPhrase.toString());
      log(response.headers.toString());

      if (response.statusCode == 200) {
        // Handle successful upload response
        // You can potentially update your UI with the new profile picture URL
        // or any other data returned by the API
        final responseBody = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseBody);

        print('Upload successful: $decodedResponse');
      } else {
        print('Upload failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
