import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_brothesbeer/models/page_manager.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/home/home_screen.dart';
import 'package:loja_virtual_brothesbeer/screens/products_list/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text("Pedidos"),
                  centerTitle: true,
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text("Parceiros"),
                  centerTitle: true,
                ),
              ),
                if(userManager.adminEnabled)
                ... [
                  AdminUsersScreen(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      title: const Text("Pedidos recebidos"),
                      centerTitle: true,
                    ),
                  ),
                ]
            ],
          );
        }
      ),
    );
  }
}
