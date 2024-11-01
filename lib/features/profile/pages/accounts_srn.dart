// saran
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/profile/widgets/account_widgets.dart';
import 'package:miogra/models/profile/single_users_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Consider using a state management solution like Provider or BLoC
// for complex data handling and better separation of concerns

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // Use a flag to indicate data loading/error state
  bool _isLoading = true;
  // Use an empty list by default to avoid null safety issues
  List<User> _singleUsersData = [];
  // Consider using an error state variable for specific error handling

  Future<void> _fetchSingleUsersData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("api_response");

      if (userId == null) {
        // Handle case where user ID is not found in preferences
        throw Exception('User ID not found in preferences');
      }

      final response = await http.get(Uri.parse(
          'https://${ApiServices.ipAddress}/single_users_data/$userId'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        setState(() {
          _singleUsersData =
              responseData.map((json) => User.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load user data (Status code: ${response.statusCode})');
      }
    } on Exception catch (error) {
      // Handle network errors or other exceptions more gracefully
      setState(() {
        _isLoading = false;
      });
      // Consider displaying a user-friendly error message
      log('Error fetching user data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSingleUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        // centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _singleUsersData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Text('No user data found'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'SignIn',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) // Informative message
              : Column(
                  children: [
                    profile(
                      context,
                      _singleUsersData[0].fullName,
                      _singleUsersData[0].email,
                      _singleUsersData[0].profilePicture,
                      _singleUsersData[0].phoneNumber,
                    ),
                    const SizedBox(height: 20),
                    const ListTile(
                      leading: Icon(Icons.money),
                      title: Text('Upi and Bank Details'),
                      tileColor: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    const ListTile(
                      leading: Icon(Icons.legend_toggle_sharp),
                      title: Text('Legal and Policies'),
                      tileColor: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    const ListTile(
                      leading: Icon(Icons.insert_link_outlined),
                      title: Text('About Us'),
                      tileColor: Colors.white,
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Logout'),
                      // trailing: Icon(Icons.edit),
                      tileColor: Colors.white,
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
    );
  }
}
