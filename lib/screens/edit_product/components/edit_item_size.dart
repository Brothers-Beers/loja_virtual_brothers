import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/commons/custom_icon_button.dart';
import 'package:loja_virtual_brothesbeer/models/item_size.dart';

class EditItemSize extends StatelessWidget {

  const EditItemSize({Key key, this.size, this.onRemove,
    this.onMoveUp, this.onMoveDown}) : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true
            ),
            validator: (name){
              if(name.isEmpty)
                return 'Inválido';
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(height: 4,),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
                labelText: 'Estoque',
                isDense: true
            ),
            keyboardType: TextInputType.number,
            validator: (stock){
              if(stock.isEmpty || int.tryParse(stock) == null)
                return 'Inválido';
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(height: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
                labelText: 'Preço',
                isDense: true,
                prefixText: 'R\$ '
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price){
              if(price.isEmpty || num.tryParse(price) == null)
                return 'Inválido';
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),
        CustomIconButtom(
            iconData: Icons.remove,
            color: Colors.red,
            onTap: onRemove,
        ),
        CustomIconButtom(
            iconData: Icons.arrow_drop_up,
            color: Colors.black,
            onTap: onMoveUp,
        ),
        CustomIconButtom(
            iconData: Icons.arrow_drop_down,
            color: Colors.black,
            onTap: onMoveDown,
        )
      ],
    );
  }
}
