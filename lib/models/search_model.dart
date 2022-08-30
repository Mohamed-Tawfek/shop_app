import 'package:shop_app/models/products_model.dart';

class SearchModel {
  late bool status;
  late List<ProductModel> products = [];

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    json['data']['data'].forEach((product) {
      products.add(ProductModel.fromJson(product));
    });
  }
}
