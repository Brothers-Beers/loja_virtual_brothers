import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/product_manager.dart';
import 'package:loja_virtual_brothesbeer/models/products.dart';
import 'package:loja_virtual_brothesbeer/screens/edit_product/components/images_form.dart';
import 'package:loja_virtual_brothesbeer/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p)
      : editing = p != null,
        product = p != null ? p.clone() : Product();

  final Product product;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar produto' : 'Criar produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                          hintText: 'Título do produto',
                          border: InputBorder.none),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                      validator: (name) {
                        if (name.isEmpty || name.length < 6)
                          return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'Descrição', border: InputBorder.none),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (description) =>
                          product.description = description,
                    ),
                    SizesForm(product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(builder: (_, product, __) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: !product.loading
                              ? () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();

                                    await product.save();

                                    context.read<ProductManager>().update(product);

                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          textColor: Colors.white,
                          color: primaryColor,
                          disabledColor: primaryColor.withAlpha(100),
                          child: product.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
