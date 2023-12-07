import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vente/Widgets/productWidget.dart';
import 'package:vente/loginPage.dart';
import 'package:vente/shared/shared.dart';

import 'Widgets/product_widget_home.dart'; // Importer la page de login

class HomePage extends StatelessWidget {
  HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenue',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.indigo],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('produit').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur de chargement des produits');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('Aucun produit trouvé');
            } else {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var productData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return ProductItemHome(
                    onProductAddedToFavorites: () {
                      favoriteProducts.add(ProductItemHome(
                        imageUrl: productData['imageUrl'],
                        title: productData['titre'],
                        prix: productData['prix'],
                      ));
                    },
                    onProductAdded: () {
                      ProductItem productItem = ProductItem(imageUrl: productData['imageUrl'], title: productData['titre'], prix: productData['prix'], quantite: productData['quntite']);
                      cartItem.add(productItem);
                    },

                    imageUrl: productData['imageUrl'],
                    title: productData['titre'],
                    prix: productData['prix'],

                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
