import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vente/page/favoritePage.dart';
import 'package:vente/page/homePage.dart';

import 'page/cartPage.dart';

class LendingPage extends StatefulWidget {
  LendingPage({super.key});

  @override
  State<LendingPage> createState() => _LendingPageState();
}

class _LendingPageState extends State<LendingPage> {
  List<String> titles = ['Home Page', 'Cart Page', 'Favorite Page'];

  List<Widget> page = [HomePage(), CartPage(), FavoritePage()];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        leading: Icon(Icons.menu),
        centerTitle: true,
      ),
      body: page[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'favorite'),
          ],
          currentIndex: currentIndex,
          onTap: (index) {
            currentIndex = index;

            setState(() {

            });
          }),
    );
  }
}
