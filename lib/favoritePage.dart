import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vente/shared/shared.dart';


class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
    _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return favoriteProducts.isEmpty? Container(child: Text("cart empty"),):favoriteProducts[index];
        },
      ),
      
    );
  }
}

