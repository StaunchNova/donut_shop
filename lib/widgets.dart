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
              child: Container(),
            ),
            const DonutBottomBar(),
          ],
        ));
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
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('main');
                },
                icon: Icon(Icons.trip_origin,
                    color: bottomBarSelectionService.tabSelection == 'main'
                        ? Utils.mainColor
                        : Utils.mainColor),
              ),
              IconButton(
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('favorite');
                },
                icon: const Icon(Icons.favorite, color: Utils.mainColor),
              ),
              IconButton(
                onPressed: () {
                  bottomBarSelectionService.setTabSelection('shoppingcart');
                },
                icon: const Icon(Icons.shopping_cart, color: Utils.mainColor),
              )
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
    notifyListeners();
  }
}
