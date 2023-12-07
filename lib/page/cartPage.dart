import 'package:flutter/material.dart';
import 'package:vente/Widgets/product_widget_cart.dart';
import 'package:vente/shared/shared.dart';

class CartPage extends StatefulWidget {
  // Utilisez un Map pour stocker plusieurs détails de l'article

  CartPage({Key? key,}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cartItem.length,
        itemBuilder: (BuildContext context, int index) {
          int newQuantite=0;
          return cartItem.isEmpty
              ? Container(child: Text("Cart is empty"))
              : ProductItem(

            quantite: cartItem[index].quantite,
            onQuantityChanged: (newQuantite) {

              setState(() {
                cartItem[index].quantite = newQuantite;
              });
            },
            imageUrl: cartItem[index].imageUrl,
            title: cartItem[index].title,
            prix:cartItem[index].prix,
              id :cartItem[index].id,
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Text(
          'Total: ${calculateTotal(cartItem)}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  double calculateTotal(List<ProductItem> cartItem) {
    double total = 0;
    for (var item in cartItem) {
      // Ajoutez le prix total de chaque article multiplié par sa quantité
      total += double.parse(item.prix) * item.quantite;
    }
    return total;
  }
}