import 'package:flutter/foundation.dart';

class CategoryModel{
  bool? status;
  List<CategoryDataModel> data=[];
  CategoryModel.fromJson(Map<String,dynamic>json){
status=json['status'];
json['data']['data'].forEach((e){
  data.add(CategoryDataModel.fromJson(e));

});


  }


}
class CategoryDataModel{
int? id;
String? name;
String? image;
  CategoryDataModel.fromJson(Map<String,dynamic>json){

id=json['id'];
name=json['name'];
image=json['image'];


  }



}