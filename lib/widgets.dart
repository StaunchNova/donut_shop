import 'dart:ui';

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
                      page = const DonutShoppingCartPage();
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
          child: Consumer<DonutService>(
            builder: (context, donutService, child) {
              return DonutList(donuts: donutService.filteredDonuts);
            },
            // child: DonutList(
            //   donuts: Utils.donuts,
            // ),
          ),
        )
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
      color: Colors.black,
      padding: const EdgeInsets.all(10),
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
      height: 300,
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
              margin:
                  const EdgeInsets.only(top: 0, bottom: 5, left: 10, right: 10),
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
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<DonutModel> insertedItems = [];
  @override
  void initState() {
    super.initState();
    var future = Future(() {});
    for (var i = 0; i < widget.donuts!.length; i++) {
      future = future.then((_) {
        return Future.delayed(const Duration(milliseconds: 125), () {
          insertedItems.add(widget.donuts![i]);
          _key.currentState!.insertItem(i);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _key,
      scrollDirection: Axis.horizontal,
      initialItemCount: insertedItems.length,
      itemBuilder: (context, index, Animation) {
        DonutModel currentDonut = widget.donuts![index];
        return DonutCard(donutInfo: currentDonut);
      },
    );
  }
}

class DonutCard extends StatelessWidget {
  DonutModel? donutInfo;
  DonutCard({this.donutInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var donutService = Provider.of<DonutService>(context, listen: false);
        donutService.onDonutSelected(donutInfo!);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.all(15),
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
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: donutInfo!.name!,
              child: Image.network(
                donutInfo!.imgUrl!,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
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
  List<DonutModel> filteredDonuts = [];
  late DonutModel selectedDonut;
  DonutModel getSelectedDonut() {
    return selectedDonut;
  }

  void onDonutSelected(DonutModel donut) {
    selectedDonut = donut;
    Utils.mainAppNav.currentState!.pushNamed('/details');
  }

  DonutService() {
    selectedDonutType = filterBarItems.first.id;
    filteredDonutsByType(selectedDonutType!);
  }
  void filteredDonutsByType(String type) {
    selectedDonutType = type;
    filteredDonuts =
        Utils.donuts.where((d) => d.type == selectedDonutType).toList();
    notifyListeners();
  }
}

class DonutShopDetails extends StatefulWidget {
  const DonutShopDetails({Key? key}) : super(key: key);

  @override
  State<DonutShopDetails> createState() => _DonutShopDetailsState();
}

class _DonutShopDetailsState extends State<DonutShopDetails>
    with SingleTickerProviderStateMixin {
  DonutModel? selectedDonut;
  AnimationController? controller;
  Animation<double>? rotationAnimation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 20), vsync: this)
          ..repeat();
    rotationAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.linear));
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DonutService donutService =
        Provider.of<DonutService>(context, listen: false);
    selectedDonut = donutService.getSelectedDonut();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Utils.mainDark),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: SizedBox(
            width: 120,
            child: Image.network(Utils.donutLogoRedText),
          ),
        ),
        actions: const [
          DonutShoppingCartBadge(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.1,
            child: Stack(
              children: [
                Hero(
                  tag: selectedDonut!.name!,
                  child: Positioned(
                    top: -60,
                    right: -120,
                    child: RotationTransition(
                      turns: rotationAnimation!,
                      child: Image.network(
                        selectedDonut!.imgUrl!,
                        width: MediaQuery.of(context).size.width * 1.25,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDonut!.name!,
                        style: const TextStyle(
                            color: Utils.mainDark,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline),
                      color: Utils.mainDark,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Utils.mainDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${selectedDonut!.price!.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(selectedDonut!.description!),
                Consumer<DonutShoppingCartService>(
                  builder: (context, cartService, child) {
                    if (!cartService.isDonutInCart(selectedDonut!)) {
                      return GestureDetector(
                        onTap: () {
                          cartService.addToCart(selectedDonut!);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Utils.mainDark.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.shopping_cart, color: Utils.mainDark),
                              SizedBox(width: 20),
                              Text(
                                'Add To Cart',
                                style: TextStyle(color: Utils.mainDark),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_rounded, color: Utils.mainDark),
                          SizedBox(width: 20),
                          Text(
                            'Added to Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utils.mainDark),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class DonutShoppingCartService extends ChangeNotifier {
  List<DonutModel> cartDonuts = [];
  void addToCart(DonutModel donut) {
    cartDonuts.add(donut);
    notifyListeners();
  }

  void removeFromCart(DonutModel donut) {
    cartDonuts.removeWhere((d) => d.name == donut.name);
    notifyListeners();
  }

  void clearCart() {
    cartDonuts.clear();
    notifyListeners();
  }

  double getTotal() {
    double cartTotal = 0.0;
    cartDonuts.forEach((element) {
      cartTotal += element.price!;
    });
    return cartTotal;
  }

  bool isDonutInCart(DonutModel donut) {
    return cartDonuts.any((d) => d.name == donut.name);
  }
}

class DonutShoppingCartBadge extends StatelessWidget {
  const DonutShoppingCartBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DonutShoppingCartService>(
      builder: (context, cartService, child) {
        if (cartService.cartDonuts.isEmpty) {
          return const SizedBox();
        }
        return Transform.scale(
          scale: 0.7,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Utils.mainColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                Text(
                  '${cartService.cartDonuts.length}',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.shopping_cart, size: 25, color: Colors.white)
              ],
            ),
          ),
        );
      },
    );
  }
}

class DonutShoppingCartPage extends StatefulWidget {
  const DonutShoppingCartPage({Key? key}) : super(key: key);

  @override
  State<DonutShoppingCartPage> createState() => _DonutShoppingCartPageState();
}

class _DonutShoppingCartPageState extends State<DonutShoppingCartPage>
    with SingleTickerProviderStateMixin {
  AnimationController? titleAnimation;
  @override
  void initState() {
    super.initState();
    titleAnimation = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..forward();
  }

  @override
  void dispose() {
    titleAnimation!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: titleAnimation!, curve: Curves.easeInOut),
            ),
            child: Image.network(
              Utils.donutTitleMyDonuts,
              width: 170,
            ),
          ),
          Expanded(
            child: Consumer<DonutShoppingCartService>(
                builder: (context, cartService, child) {
              if (cartService.cartDonuts.isEmpty) {
                return Center(
                  child: SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart,
                            color: Colors.grey[300], size: 50),
                        const SizedBox(height: 20),
                        const Text(
                          'You don\'t have any items on your cart yet! ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                );
              }
              return DonutShoppingListRow();
            }),
          ),
        ],
      ),
    );
  }
}

class DonutShoppingListRow extends StatelessWidget {
  DonutModel? donut;
  Function? onDeleteRow;
  DonutShoppingListRow({
    this.onDeleteRow,
    this.donut,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
      child: Row(
        children: [
          Image.network('${donut!.imgUrl}', width: 80, height: 80),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${donut!.name}',
                  style: const TextStyle(
                      color: Utils.mainDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Utils.mainDark.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '\$${donut!.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Utils.mainDark.withOpacity(0.4)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_forever,
              color: Utils.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
