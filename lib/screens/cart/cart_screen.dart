import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/commons/price_card.dart';
import 'package:loja_virtual_brothesbeer/models/cart_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: "Continue para entrega >>",
                onPressed: cartManager.isCartValid ? (){
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
