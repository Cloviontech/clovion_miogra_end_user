import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miogra/core/colors.dart';
// import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/auth/presentation/pages/signup.dart';
import 'package:miogra/features/dOriginal/presentation/pages/d_original_landing_page.dart';
import 'package:miogra/features/dailyMio/presentation/pages/daily_mio_landing_page.dart';
import 'package:miogra/features/food/presentation/pages/food_landing_page.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_landing_page.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewellery_landing_page.dart';
import 'package:miogra/features/pharmacy/presentation/pages/pharmacy_landing_page.dart';
import 'package:miogra/features/profile/pages/accounts_srn.dart';
import 'package:miogra/features/profile/pages/myCart_srn.dart';
// import 'package:miogra/features/profile/pages/order.dart';
import 'package:miogra/features/profile/pages/order_1_srn.dart';
// import 'package:miogra/features/profile/pages/return.dart';
import 'package:miogra/features/profile/pages/wishlist.dart';
import 'package:miogra/features/profile/pages/wishlist1_srn.dart';
import 'package:miogra/features/shopping/presentation/pages/shopping_landing_page.dart';
import 'package:miogra/features/usedProducts/pages/used_products_landing_page.dart';
import 'package:badges/badges.dart' as badge;
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = 'a';

  bool UserSignedIn = false;

  Future<void> getUserIdInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();

      // UserSignedIn = true;
    });

    // prefs.clear();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexBotNav = index;
    });
  }

  bool notification = false;
  int selectedIndex = 0;
  int selectedIndexBotNav = 0;

  final List<Widget> _pages = [
    const WishList(),
    // const MyCart(),
    // const ReturnPage(),
    // const OrderPage(),
    const DeleveredProductList(),
    // const OrderPage1(),
    const Wishlist1(),
    const Account(),
    // signin(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserIdInSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 200),
      length: 8,
      initialIndex: 0,
      child: Scaffold(
        // appBar: AppBar(title: Text(userId),),
        body: selectedIndexBotNav == 0
            ? NestedScrollView(
                headerSliverBuilder: (context, scroll) => [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        backgroundColor: const Color(0xFF870081),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              'assets/images/Miogra.svg',
                              width: 50,
                            ),
                            const Text(
                              "iogra",
                              style: TextStyle(
                                  fontFamily: 'Agbalumo',
                                  letterSpacing: 1.7,
                                  fontSize: 17,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        leadingWidth: 150,
                        pinned: true,
                        floating: true,
                        snap: true,
                        expandedHeight: 120,
                        actions: [
                          Padding(
                            padding: (notification)
                                ? const EdgeInsets.only(top: 2)
                                : const EdgeInsets.only(top: 2),
                            child: (notification)
                                ? const Icon(
                                    Icons.notifications_rounded,
                                    size: 25,
                                    color: Colors.white,
                                  )
                                : badge.Badge(
                                    position: badge.BadgePosition.topEnd(
                                        top: 11, end: 15),
                                    badgeStyle: const badge.BadgeStyle(
                                        badgeColor: Color(0xff13b436),
                                        padding: EdgeInsets.all(4)),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.notifications_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                          ),
                          (notification)
                              ? const SizedBox(width: 21.9)
                              : const SizedBox(width: 10.5)
                        ],
                        bottom: TabBar(
                          isScrollable: true,
                          indicatorPadding: const EdgeInsets.only(
                            bottom: .15,
                          ),
                          indicatorWeight: 3,
                          indicatorColor: Colors.white,
                          labelPadding: const EdgeInsets.only(
                            right: 15,
                            left: 15,
                          ),
                          labelStyle: const TextStyle(
                              fontSize: 15.7, color: Colors.white),
                          unselectedLabelStyle: const TextStyle(
                              fontSize: 12, color: Colors.white54),
                          tabs: [
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/shop.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Shopping',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/pasta.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Food',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/meat.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Fresh Cuts',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/shop.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Daily Mio',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/gold.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Jewellery',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/shop.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'D Original',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/shop.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Pharmacy',
                            ),
                            Tab(
                              icon: SvgPicture.asset(
                                'assets/icons/recycle.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 25,
                              ),
                              text: 'Used Products',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // body: const FoodLandingPage(),
                // body: const ShoppingLadingPage(),
                body:
                    //
                    // _pages.elementAt(selectedIndexBotNav),

                    const TabBarView(
                  children: [
                    ShoppingLadingPage(),
                    FoodLandingPage(),
                    FreshCutLandingPage(),
                    DailyMioLandingPage(),
                    JewelleryLandingPage(),
                    DOriginalLandingPage(),
                    PharmacyLandingPage(),
                    UsedProductsLandingPage(),
                  ],
                ),
              )
            : selectedIndexBotNav == 4 && userId.toString() == null.toString()

                //  UserSignedIn == false

                ? const SignUp()
                : _pages.elementAt(selectedIndexBotNav),

        bottomNavigationBar: SizedBox(
          height: 47,
          child: BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 0,
              letterSpacing: 1,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 0,
              letterSpacing: 1,
            ),
            currentIndex: selectedIndexBotNav,
            onTap: (index) {
              setState(() {
                //  userId == null.toString() ?
                selectedIndexBotNav =
                    //  5 :
                    index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(
                    BootstrapIcons.house_door,
                    size: 28,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: badge.Badge(
                    badgeContent: const Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    position: badge.BadgePosition.topEnd(top: -5, end: -5),
                    badgeStyle: const badge.BadgeStyle(
                      badgeColor: Color(0xff13b436),
                    ),
                    child: const Icon(
                      BootstrapIcons.cart,
                      size: 25,
                    ),
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    BootstrapIcons.bag,
                    size: 28,
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    BootstrapIcons.heart,
                    size: 28,
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    BootstrapIcons.person_circle,
                    size: 28,
                  ),
                  label: ''),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       notification = !notification;
        //     });
        //   },
        // ),
      ),
    );
  }
}
