import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
      children: [
        const DonutPager(),
        const DonutFilterBar(),
        Expanded(
            child: DonutList(
          donuts: Utils.donuts,
        ))
      ],
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
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
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
                  child: Image.network(
                    currentPage.logoImgUrl!,
                    width: 120,
                  ),
                );
              }),
            ),
          ),
          PageViewIndicator(
            controller: controller,
            numberOfPages: pages.length,
            currentPage: currentPage,
          )
        ],
      ),
    );
  }
}

class PageViewIndicator extends StatelessWidget {
  PageController? controller;
  int? numberOfPages;
  int? currentPage;
  PageViewIndicator({this.controller, this.numberOfPages, this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfPages!, (index) {
        return GestureDetector(
          onTap: () {
            controller!.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: 15,
              height: 15,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: currentPage == index
                    ? Utils.mainColor
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class DonutFilterBar extends StatelessWidget {
  const DonutFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment alignmentBasedOnTap(filterBarId) {
      switch (filterBarId) {
        case 'classic':
          return Alignment.centerLeft;
        case 'sprinkled':
          return Alignment.center;
        case 'stuffed':
          return Alignment.centerRight;
        default:
          return Alignment.centerLeft;
      }
    }

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<DonutService>(
          builder: (context, donutService, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(donutService.filterBarItems.length,
                      (index) {
                    DonutFilterBarItem item =
                        donutService.filterBarItems[index];
                    return GestureDetector(
                      onTap: () {
                        donutService.filteredDonutsByType(item.id!);
                      },
                      child: Text(
                        item.label!,
                        style: TextStyle(
                            color: donutService.selectedDonutType == item.id
                                ? Utils.mainColor
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    AnimatedAlign(
                      alignment:
                          alignmentBasedOnTap(donutService.selectedDonutType),
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3 - 20,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Utils.mainColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }
}

class DonutList extends StatefulWidget {
  List<DonutModel>? donuts;
  DonutList({this.donuts});

  @override
  State<DonutList> createState() => _DonutListState();
}

class _DonutListState extends State<DonutList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        DonutModel currentDonut = widget.donuts![index];
        return DonutCard(
          donutInfo: currentDonut,
        );
      },
    );
  }
}

class DonutCard extends StatelessWidget {
  DonutModel? donutInfo;
  DonutCard({this.donutInfo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 150,
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0.0, 4.0),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${donutInfo!.name}',
                style: const TextStyle(
                    color: Utils.mainDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Utils.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 5),
                child: Text(
                  '\$${donutInfo!.price!.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class DonutPage {
  String? imgUrl;
  String? logoImgUrl;
  DonutPage({this.imgUrl, this.logoImgUrl});
}

class DonutFilterBarItem {
  String? id;
  String? label;
  DonutFilterBarItem({
    this.id,
    this.label,
  });
}

class DonutService extends ChangeNotifier {
  List<DonutFilterBarItem> filterBarItems = [
    DonutFilterBarItem(id: 'classic', label: 'Classic'),
    DonutFilterBarItem(id: 'sprinkled', label: 'Sprinkled'),
    DonutFilterBarItem(id: 'stuffed', label: 'Stuffed')
  ];
  String? selectedDonutType;
  DonutService() {
    selectedDonutType = filterBarItems.first.id;
  }
  void filteredDonutsByType(String type) {
    selectedDonutType = type;
    notifyListeners();
  }
}
