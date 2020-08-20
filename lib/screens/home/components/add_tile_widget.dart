import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/models/section.dart';
import 'package:loja_virtual_brothesbeer/models/section_items.dart';
import 'package:loja_virtual_brothesbeer/screens/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();

    void onImageSelected(File file){
      section.addItem(SectionItems(image: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: (){
          if(Platform.isAndroid)
            showModalBottomSheet(
                context: context,
                builder: (_) => ImageSourceSheet(
                  onImageSelected: onImageSelected,
                )
            );
        },
        child: Container(
          color: Colors.white.withAlpha(50),
          child: const Icon(
              Icons.add,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}
