import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 400),
      length: 8,
      initialIndex: 0,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, scroll) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
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
                            fontSize: 17),
                      ),
                    ],
                  ),
                  leadingWidth: 150,
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: 120,
                  actions: const [],
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorPadding: const EdgeInsets.only(
                      bottom: .15,
                    ),
                    indicatorWeight: 2,
                    indicatorColor: Colors.white,
                    labelPadding: const EdgeInsets.only(
                      right: 15,
                      left: 15,
                      bottom: 0,
                    ),
                    labelStyle: const TextStyle(fontSize: 15.7),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 12,
                    ),
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
          body: const Column(),
          // body: const SliverFillRemaining(
          //   child:
        ),
      ),
    );
  }
}
