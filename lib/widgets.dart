import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class DonutShopMain extends StatelessWidget {
  const DonutShopMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Utils.mainDark),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Image.network(
            Utils.donutLogoRedText,
            width: 120,
          ),
        ),
        drawer: const Drawer(
          child: DonutSideMenu(),
        ),
        body: Column(
          children: [
            Expanded(
              child: Navigator(
                key: Utils.mainListNav,
                initialRoute: '/main',
                onGenerateRoute: (RouteSettings settings) {
                  Widget page;
                  switch (settings.name) {
                    case '/main':
                      page = const DonutMainPage();
                      break;
                    case '/favorites':
                      page = const Center(child: Text('shopping cart'));
                      break;
                    case '/shoppingcart':
                      page = const Center(child: Text('shopping cart'));
                      break;
                    default:
                      page = const Center(child: Text('main'));
                      break;
                  }
                  return PageRouteBuilder(
                      pageBuilder: (_, __, ___) => page,
                      transitionDuration: const Duration(seconds: 0));
                },
              ),
            ),
            const DonutBottomBar(),
          ],
        ));
  }
}

class DonutMainPage extends StatelessWidget {
  const DonutMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [DonutPager()],
    );
  }
}

class DonutSideMenu extends StatelessWidget {
  const DonutSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.mainDark,
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Image.network(
              Utils.donutLogoWhiteNoText,
              width: 100,
            ),
          ),
          Image.network(
            Utils.donutLogoWhiteText,
            width: 150,
          )
        ],
      ),
    );
  }
}

class DonutBottomBar extends StatelessWidget {
  const DonutBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Consumer<DonutBottomBarSelectionService>(
        builder: (context, bottomBarSelectionService, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.trip_origin,
                    color: bottomBarSelectionService.tabSelection == 'main'
                        ? Utils.mainDark
                        : Utils.mainColor),
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('main');
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite,
                    color: bottomBarSelectionService.tabSelection == 'favorites'
                        ? Utils.mainDark
                        : Utils.mainColor),
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('favorites');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color:
                      bottomBarSelectionService.tabSelection == 'shoppingcart'
                          ? Utils.mainDark
                          : Utils.mainColor,
                ),
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('shoppingcart');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DonutBottomBarSelectionService extends ChangeNotifier {
  String? tabSelection = 'main';
  void setTabSelection(String selection) {
    Utils.mainListNav.currentState!.pushReplacementNamed('/' + selection);
    tabSelection = selection;
    notifyListeners();
  }
}

class DonutPager extends StatefulWidget {
  const DonutPager({Key? key}) : super(key: key);

  @override
  State<DonutPager> createState() => _DonutPagerState();
}

class _DonutPagerState extends State<DonutPager> {
  List<DonutPage> pages = [
    DonutPage(imgUrl: Utils.donutPromo1, logoImgUrl: Utils.donutLogoWhiteText),
    DonutPage(imgUrl: Utils.donutPromo2, logoImgUrl: Utils.donutLogoWhiteText),
    DonutPage(imgUrl: Utils.donutPromo3, logoImgUrl: Utils.donutLogoRedText),
  ];
  int currentPage = 0;
  PageController? controller;
  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              controller: controller,
              children: List.generate(pages.length, (index) {
                DonutPage currentPage = pages[index];
                return Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0.0, 5.0))
                    ],
                    image: DecorationImage(
                        image: NetworkImage(currentPage.imgUrl!),
                        fit: BoxFit.cover),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class DonutPage {
  String? imgUrl;
  String? logoImgUrl;
  DonutPage({this.imgUrl, this.logoImgUrl});
}
