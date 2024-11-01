import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/food/presentation/pages/food_landing_page.dart';
import 'package:miogra/features/freshCuts/presentation/pages/fresh_cut_landing_page.dart';
import 'package:miogra/features/jewellery/presentation/pages/jewellery_landing_page.dart';
import '../../features/dOriginal/presentation/pages/d_original_landing_page.dart';
import '../../features/dailyMio/presentation/pages/daily_mio_landing_page.dart';
import '../../features/pharmacy/presentation/pages/pharmacy_landing_page.dart';
import '../../features/usedProducts/pages/used_products_landing_page.dart';
import '../tabs/all_product_shoping.dart';

class TabBarItems extends StatefulWidget {
  const TabBarItems({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabBarItemsState createState() => _TabBarItemsState();
}

class _TabBarItemsState extends State<TabBarItems>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
        initialIndex: 1,
        length: 8, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 5.0,
        tabAlignment: TabAlignment.start,
        tabs: [
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 25,
            ),
            text: 'Shopping',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/pasta.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Food',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/meat.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Fresh Cuts',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Daily Mio',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/gold.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Jewellery',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'D Original',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/shop.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Pharmacy',
          ),
          Tab(
            icon: SvgPicture.asset(
              'assets/icons/recycle.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 25,
            ),
            text: 'Used Products',
          ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          AllProductShoping(),
          FoodLandingPage(),
          FreshCutLandingPage(),
          DailyMioLandingPage(),
          JewelleryLandingPage(),
          DOriginalLandingPage(),
          PharmacyLandingPage(),
          UsedProductsLandingPage(),
        ],
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final String title;

  const TabPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
