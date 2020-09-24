import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/address.dart';
import 'package:loja_virtual_brothesbeer/models/cart_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/address/components/address_input_field.dart';
import 'package:loja_virtual_brothesbeer/screens/address/components/cep_input_field.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(builder: (_, cartManager, __) {
      final address = cartManager.address ?? Address();

      return Form(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Endereço de entrega',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                CepInputField(address),
                AddressInputField(address),
              ],
            ),
          ),
        ),
      );
    });
  }
}
