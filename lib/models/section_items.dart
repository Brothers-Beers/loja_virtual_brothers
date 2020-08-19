class SectionItems {

  SectionItems({this.image, this.product});

  SectionItems.fromMap(Map<String, dynamic> map){
    image = map['image'] as String;
    product = map['product'] as String;
  }

  String image;
  String product;

  SectionItems clone(){
    return SectionItems(
      image: image,
      product: product
    );
  }

  @override
  String toString() {
    return 'SectionItems{image: $image, product: $product}';
  }
}