import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/commons/custom_icon_button.dart';
import 'package:loja_virtual_brothesbeer/models/cart_product.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {

  const CartTile(this.cartProduct);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartProduct,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(cartProduct.product.images.first),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            cartProduct.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                              "${cartProduct.product.typeText} ${cartProduct.size}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 17.0
                            ),
                          ),
                        ),
                        Consumer<CartProduct>(
                            builder: (_, cartProduct, __) {
                              if (cartProduct.hasStock) {
                                return Text(
                                  "R\$ ${cartProduct.unitPrice.toStringAsFixed(
                                      2)}",
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                );
                            } else {
                                return const Text(
                                    "Estoque indisponível no momento",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12
                                  ),
                                );
                              }
                            }
                        )
                      ],
                    ),
                  )
              ),
              Consumer<CartProduct>(
                 builder: (_, cartProduct, __){
                   return Column(
                     children: [
                       if(cartProduct.hasStock)
                       CustomIconButtom(
                         iconData: Icons.add,
                         color: Theme.of(context).primaryColor,
                         onTap: cartProduct.increment,
                       ),
                       Text(
                         "${cartProduct.quantity}",
                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                       ),
                       CustomIconButtom(
                         iconData: cartProduct.quantity == 1 ? Icons.delete : Icons.remove,
                         color: cartProduct.quantity == 1 ? Colors.redAccent : Colors.grey[500],
                         onTap: cartProduct.decrement,
                       ),
                     ],
                   );
                 }
              )
            ],
          ),
        ),
      ),
    );
  }
}
