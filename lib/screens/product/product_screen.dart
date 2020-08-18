import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/cart_manager.dart';
import 'package:loja_virtual_brothesbeer/models/products.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/product/components/size_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(
                builder: (_, userManeger, __){
                  if(userManeger.adminEnabled){
                    return IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed(
                              "/edit_product",
                            arguments: product
                          );
                        }
                    );
                  } else {
                    return Container();
                  }
                }
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                //autoplayDuration: Duration(seconds: 4),
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "A partir de",
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      color: primaryColor
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "Descrição:",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      product.typeText,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s){
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                    if (product.hasStock)
                      Consumer2<UserManager, Product>(
                        builder: (_, userManager, product, __) {
                          return SizedBox(
                            height: 44,
                            child: RaisedButton(
                              color: primaryColor,
                              textColor: Colors.white,
                              onPressed: product.selectedSize != null ? () {
                                if (userManager.isLoggedin) {
                                  context.read<CartManager>().addToCart(product);
                                  Navigator.of(context).pushNamed("/cart");
                                } else {
                                  Navigator.of(context).pushNamed("/login");
                                }
                              } : null,
                              child: Text(
                                userManager.isLoggedin
                                    ? "Adicionar ao carrinho"
                                    : "Entre para comprar",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                    ) else null,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
