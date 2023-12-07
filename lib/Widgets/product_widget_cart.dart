import 'package:flutter/material.dart';
import 'package:vente/shared/shared.dart';

class ProductItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String prix;
  final int id ;

  Function(int)? onQuantityChanged;
  final VoidCallback? onProductDeleted;
  final VoidCallback? onProductAddedToFavorites;
  int quantite;
  ProductItem({
    required this.imageUrl,
    required this.title,
    required this.prix,
    required this.id,
    this.onQuantityChanged,
    this.onProductDeleted,
    this.onProductAddedToFavorites,
    required this.quantite,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int quantite = 0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Image.network(widget.imageUrl,
                  height: 100, width: 100, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.title ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${widget.prix}" +"\$",
                      style: TextStyle(color: Colors.green, fontSize: 14.0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (widget.quantite > 0) {
                                widget.onQuantityChanged!(widget.quantite - 1);
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        Text("${widget.quantite}", style: TextStyle(fontSize: 18.0)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.onQuantityChanged!(widget.quantite + 1);
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              int indexToRemove = cartItem.indexWhere((item) =>
                              item.imageUrl == widget.imageUrl &&
                                  item.title == widget.title &&
                                  item.prix == widget.prix &&
                                  item.id == widget.id &&
                                  item.quantite == widget.quantite
                              );
                              if (indexToRemove != -1) {
                                cartItem.removeAt(indexToRemove);
                              }
                            });
                          },

                          child: Text("Delete"),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              if (isFavorite) {
                                widget.onProductAddedToFavorites
                                    ?.call(); // Appel de la fonction d'ajout aux favoris
                              }

                            });
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : null, // Couleur du cœur
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
