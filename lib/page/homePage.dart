import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vente/Widgets/product_widget_cart.dart';
import 'package:vente/Widgets/product_widget_favorite.dart';

import 'package:vente/shared/shared.dart';

import '../Widgets/product_widget_home.dart';
import '../login/LoginPage.dart'; // Importer la page de login

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
              Navigator.push(
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
                      ProductItemFavorite productItem = ProductItemFavorite(
                        quantite: productData['quntite'],
                        imageUrl: productData['imageUrl'],
                        title: productData['titre'],
                        prix: productData['prix'],
                        id: productData['id'],
                      );

                      // Vérifie si un élément avec le même ID existe déjà dans favoriteProducts
                      int idToAdd = -1;
                      for (int i = 0; i < favoriteProducts.length; i++) {
                        if (favoriteProducts[i].id == productItem.id) {
                          idToAdd = i;
                          break;
                        }
                      }
                      if (idToAdd != -1) {
                        favoriteProducts.removeAt(idToAdd);
                      }
                      // Sinon, l'ajouter
                      else {
                        favoriteProducts.add(productItem);
                      }
                    },
                    onProductAdded: () {
                      ProductItem productItem = ProductItem(
                          imageUrl: productData['imageUrl'],
                          title: productData['titre'],
                          prix: productData['prix'],
                          quantite: productData['quntite'],
                          id: productData['id']);
                      int idToRemove = -1;
                      for (int i = 0; i < cartItem.length; i++) {
                        if (cartItem[i].id == productItem.id) {
                          idToRemove = i;
                          break;
                        }
                      }

                      // Si un élément avec le même ID est trouvé, le supprimer
                      if (idToRemove != -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Ce produit est déja ajouter"),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      } else {
                        cartItem.add(productItem);
                      }
                    },
                    imageUrl: productData['imageUrl'],
                    title: productData['titre'],
                    prix: productData['prix'],
                    id: productData['id'],
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
