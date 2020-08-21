import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/admin_users_manager.dart';
import 'package:loja_virtual_brothesbeer/models/cart_manager.dart';
import 'package:loja_virtual_brothesbeer/models/home_manager.dart';
import 'package:loja_virtual_brothesbeer/models/product_manager.dart';
import 'package:loja_virtual_brothesbeer/models/products.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/base/base_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/cart/cart_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/login/login_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/product/product_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
            create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: "Brother's Beers Delivery",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/base",
        onGenerateRoute: (settings){
          switch(settings.name){
            case "/login":
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case "/signup":
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case "/product":
              return MaterialPageRoute(builder: (_) => ProductScreen(
                settings.arguments as Product
              ));
            case "/cart":
              return MaterialPageRoute(builder: (_) => CartScreen());
            case "/edit_product":
              return MaterialPageRoute(builder: (_) => EditProductScreen(
                settings.arguments as Product
              ));
            case "/select_product":
              return MaterialPageRoute(builder: (_) => SelectProductScreen());
            case "/base":
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
      ),
    );
  }
}