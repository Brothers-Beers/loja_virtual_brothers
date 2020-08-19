import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual_brothesbeer/models/home_manager.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:loja_virtual_brothesbeer/screens/home/components/section_list.dart';
import 'package:loja_virtual_brothesbeer/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            //color: Colors.white38,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white38, Colors.white70],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                snap: true,
                floating: true,
                elevation: 0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("Brother's Beers", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),),
                  centerTitle: true,
                ),
                //iconTheme: IconThemeData(color: Colors.black),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                  Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __){
                        if(userManager.adminEnabled) {
                          if(homeManager.editing) {
                            return PopupMenuButton(
                              onSelected: (e){
                                if(e == 'Salvar'){
                                  homeManager.saveEditing();
                                } else {
                                  homeManager.discardEditing();
                                }
                              },
                                itemBuilder: (_){
                                  return ['Salvar', 'Descartar'].map((e){
                                    return PopupMenuItem(
                                      value: e,
                                        child: Text(e),
                                    );
                                  }).toList();
                                }
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: homeManager.enterEditing,
                            );
                          }
                        } else return Container();
                      }
                  )
                ],
              ),
              Consumer<HomeManager>(builder: (_, homeManager, __) {
                final List<Widget> children =
                    homeManager.sections.map<Widget>(
                       (section) {
                          switch(section.type){
                            case 'List':
                              return SectionList(section);
                            case 'Staggered':
                              return SectionStaggered(section);
                            default:
                              return Container();
                          }
                       }
                    ).toList();
                return SliverList(delegate: SliverChildListDelegate(children));
              })
            ],
          ),
        ],
      ),
    );
  }
}
