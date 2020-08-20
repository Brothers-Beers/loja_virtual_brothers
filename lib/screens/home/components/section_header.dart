import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/common/commons/custom_icon_button.dart';
import 'package:loja_virtual_brothesbeer/models/home_manager.dart';
import 'package:loja_virtual_brothesbeer/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    if(homeManager.editing){
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: section.name,
              decoration: const InputDecoration(
                hintText: 'Título',
                isDense: true,
                border: InputBorder.none
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (text) => section.name = text,
            ),
          ),
          CustomIconButtom(
              iconData: Icons.remove,
              color: Colors.white,
              onTap: (){
                homeManager.removeSection(section);
              }
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          section.name ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
