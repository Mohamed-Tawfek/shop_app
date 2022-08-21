import 'package:shop_app/models/products_model.dart';

class CategoryDetailsModel {
  CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    json['data']['data'].forEach((e) {
      categoryDetails.add(ProductModel.fromJson(e));
    });
  }
  bool? status;
  List<ProductModel> categoryDetails = [];
}
