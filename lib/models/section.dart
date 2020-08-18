import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_brothesbeer/models/section_items.dart';

class Section {

  Section.fromDocument(DocumentSnapshot document){
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List).map(
            (i) => SectionItems.fromMap(i as Map<String, dynamic>)).toList();
  }

  String name;
  String type;
  List<SectionItems> items;

}