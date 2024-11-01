import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/home_page/cart_page.dart';
import 'package:miogra/home_page/navBarPages/home_page.dart';
import 'package:miogra/home_page/notifications.dart';
import 'package:miogra/my_work/cart_page.dart';
import 'package:miogra/my_work/wish_list_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../features/profile/pages/accounts_srn.dart';
// import '../features/profile/pages/myCart_srn.dart';
import '../features/profile/pages/order_1_srn.dart';
import '../features/profile/pages/wishlist1_srn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TabBarItems(),
    // const MyCart(),
    //  const CartView(),
    CartScreen(),
    const DeleveredProductList(),
   // const Wishlist1(),
    WishListScreen(),
    const Account(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Notifications(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/Miogra.svg',
                width: 30,
                height: 30,
              ),
              const Text(
                "iogra",
                style: TextStyle(
                  fontFamily: 'Agbalumo',
                  letterSpacing: 1.7,
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 150,
      )
          : null, // AppBar is null for other pages
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              BootstrapIcons.house_door,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BootstrapIcons.cart,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BootstrapIcons.bag,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BootstrapIcons.heart,
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BootstrapIcons.person_circle,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
