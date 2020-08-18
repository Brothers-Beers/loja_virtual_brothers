import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_brothesbeer/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Clientes Cadastrados'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
          builder: (_, adminUsersManager, __){
            return AlphabetListScrollView(
                itemBuilder: (_, index){
                  return ListTile(
                    title: Text(
                        adminUsersManager.users[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    subtitle: Text(
                        adminUsersManager.users[index].email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  );
                },
              highlightTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                fontSize: 20
              ),
                strList: adminUsersManager.names,
                indexedHeight: (index) => 80,
              showPreview: true,
            );
          }
      )
    );
  }

}
