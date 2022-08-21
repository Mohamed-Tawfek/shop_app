class ProductModel {
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    discount = json['discount'];
    oldPrice = json['old_price'];
    price = json['price'];
    mainImage = json['image'];
    name = json['name'];
    description = json['description'];
    otherImages = json['images'];
    inFavorites = json['in_favorites'];

    inCart = json['in_cart'];
  }
  late num id;
  late num discount;
  late num oldPrice;
  late num price;
  late String mainImage;
  late String name;
  late String description;
  late List otherImages;
  late bool inFavorites;
  late bool inCart;
}

class ProductsModel {
  ProductsModel.fromJson(Map<String, dynamic> json,) {

    status = json['status'];
    json['data']['products'].forEach((e) {
      products.add(ProductModel.fromJson(e));
    });


  }

  late bool status;
  late List<ProductModel> products = [];

}


