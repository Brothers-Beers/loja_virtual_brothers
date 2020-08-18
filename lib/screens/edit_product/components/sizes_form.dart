import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/commons/custom_icon_button.dart';
import 'package:loja_virtual_brothesbeer/models/item_size.dart';
import 'package:loja_virtual_brothesbeer/models/products.dart';
import 'package:loja_virtual_brothesbeer/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
        initialValue: product.sizes,
        validator: (sizes){
          if(sizes.isEmpty)
            return 'Insira um tamanho!';
          return null;
        },
        builder: (state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: product.typeText,
                      decoration: const InputDecoration(
                          hintText: 'tamanhos, opções, tipo ...',
                          border: InputBorder.none
                      ),
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                      onSaved: (op) => product.typeText = op,
                    ),
                  ),
                  CustomIconButtom(
                      iconData:
                      Icons.add,
                      color: Colors.black,
                      onTap: () {
                        state.value.add(ItemSize());
                        state.didChange(state.value);
                      }
                  )
                ],
              ),
              Column(
                children: state.value.map((size) {
                  return EditItemSize(
                    key: ObjectKey(size),
                    size: size,
                    onRemove: (){
                        state.value.remove(size);
                        state.didChange(state.value);
                    },
                    onMoveUp: size != state.value.first ? (){
                      final index = state.value.indexOf(size);
                      state.value.remove(size);
                      state.value.insert(index-1, size);
                      state.didChange(state.value);
                    } : null,
                    onMoveDown: size != state.value.last ? (){
                      final index = state.value.indexOf(size);
                      state.value.remove(size);
                      state.value.insert(index+1, size);
                      state.didChange(state.value);
                    } : null,
                  );
                }).toList(),
              ),
              if(state.hasError)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      state.errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
