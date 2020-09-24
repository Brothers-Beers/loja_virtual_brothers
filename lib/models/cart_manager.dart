import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual_brothesbeer/models/address.dart';
import 'package:loja_virtual_brothesbeer/models/cart_product.dart';
import 'package:loja_virtual_brothesbeer/models/products.dart';
import 'package:loja_virtual_brothesbeer/models/user.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:loja_virtual_brothesbeer/services/cepaberto_services.dart';
import 'package:geolocator/geolocator.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  User user;
  Address address;
  CartProduct cartProduct;

  num productsPrice = 0.0;
  num deliveryPrice;

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    items = cartSnap.documents
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackaBle(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);

      _onItemUpdated();
    }

    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);

    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null)
      user.cartReference
          .document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
  }

  // ignore: missing_return
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  //ADDRESS
  Future<void> getAddress(String cep) async {
    final cepAbertoServices = CepAbertoServices();

    try {
      final cepAbertoAddress = await cepAbertoServices.getAddressFromCep(cep);

      if (cepAbertoAddress != null) {
        address = Address(
            street: cepAbertoAddress.logradouro,
            district: cepAbertoAddress.bairro,
            zipCode: cepAbertoAddress.cep,
            city: cepAbertoAddress.cidade.nome,
            state: cepAbertoAddress.estado.sigla,
            lat: cepAbertoAddress.latitude,
            long: cepAbertoAddress.longitude);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setAddress(Address address) async {
    this.address = address;

    if (await calculateDelivary(address.lat, address.long)) {
      print('price $deliveryPrice');
      notifyListeners();
    } else {
      return Future.error(
          'Desculpe! não entregamos neste endereço no momento!');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  // metodo que calcula o valor do frete
  Future<bool> calculateDelivary(double lat, double long) async {
    final DocumentSnapshot doc =
        await firestore.document('auxiliar/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final max10km = doc.data['max10km'] as num;
    final max20km = doc.data['max20km'] as num;

    final base10km = doc.data['base10km'] as num;
    final base20km = doc.data['base20km'] as num;

    final vlrkm = doc.data['km'] as num;

    // calcula a distancia entre a loja e a localização do cliente em metros
    double dist =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);
    // transforma em km
    dist /= 1000.0;

    debugPrint('Distance $dist');
    if (dist <= max10km) {
      deliveryPrice = base10km + dist * vlrkm;
      return true;
    } else if (dist > max10km && dist <= max20km) {
      deliveryPrice = base20km + dist * vlrkm;
      return true;
    } else {
      return false;
    }
  }
}
