import 'package:shop_app/models/products_model.dart';

class CartDetailsModel {
  bool? status;
  num? total;
  List<CartItemsModel> items = [];
  CartDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['data']['total'];
    json['data']['cart_items'].forEach((e) {
      items.add(CartItemsModel.fromJson(e));
    });
  }
}

class CartItemsModel {
  CartItemsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductModel.fromJson(json['product']);
  }

  num? id;
  num? quantity;
  ProductModel? product;
}
