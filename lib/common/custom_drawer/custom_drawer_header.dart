import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/page_manager.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 200,
      child: Consumer<UserManager>(
        builder: (_, userManeger, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: const Text(
                  "Brothe's Beers\nDelivery",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Text(
                "Olá, ${userManeger.user?.name ?? ""}",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(userManeger.isLoggedin){
                    context.read<PageManager>().setPage(0);
                    userManeger.signOut();
                  } else {
                    Navigator.of(context).pushNamed("/login");
                  }
                },
                child: Text(
                  userManeger.isLoggedin
                      ? "Sair"
                      : "Entre ou cadastre-se  >>",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
