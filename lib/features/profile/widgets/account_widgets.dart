import 'package:flutter/material.dart';
import 'package:miogra/features/profile/pages/edit_account_srn.dart';

Widget profile(
  BuildContext context,
  String? userName,
  String? userEmail,
  String? profilePicture,
  String? phoneNumber,
) {
  return Container(
    height: 90,
    decoration: const BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
        color: Colors.grey,
        blurRadius: 5,
      )
    ]),
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    profilePicture.toString(),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userEmail!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: double.infinity,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAccount(
                      email: userEmail,
                      name: userName,
                      phoneNumber: phoneNumber.toString(),
                      image: profilePicture,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget accountList() {
  return Expanded(
    child: ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.comment_bank_outlined,
            size: 30,
          ),
          title: const Text('Upi and Bank Details'),
        );
      },
    ),
  );
}
