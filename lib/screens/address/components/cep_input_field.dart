import 'package:brasil_fields/formatter/cep_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual_brothesbeer/common/commons/custom_icon_button.dart';
import 'package:loja_virtual_brothesbeer/models/address.dart';
import 'package:loja_virtual_brothesbeer/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {
  CepInputField(this.address);

  final Address address;
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    if (address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: cepController,
            decoration: const InputDecoration(
                isDense: true, labelText: 'CEP', hintText: '00.000-000'),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty)
                return 'campo obrigatório!';
              else if (cep.length != 10) return 'CEP inválido!';
              return null;
            },
          ),
          SizedBox(
            height: 42,
            child: RaisedButton(
              onPressed: () {
                if (Form.of(context).validate()) {
                  context.read<CartManager>().getAddress(cepController.text);
                }
              },
              color: primaryColor,
              disabledColor: primaryColor.withAlpha(100),
              child: const Text(
                'Buscar CEP',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
          )
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "CEP: ${address.zipCode}",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
           CustomIconButtom(
                iconData: Icons.edit,
                color: primaryColor,
                size: 20,
                onTap: (){
                  context.read<CartManager>().removeAddress();
                }
            )
          ],
        ),
      );
  }
}
