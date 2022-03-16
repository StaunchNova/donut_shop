import 'package:flutter/material.dart';

import 'main.dart';

class DonutShopMain extends StatelessWidget {
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
      body: const Center(
        child: Text('Hello, Donut Shop!'),
      ),
    );
  }
}
