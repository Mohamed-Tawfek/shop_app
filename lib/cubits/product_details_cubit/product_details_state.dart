part of 'product_details_cubit.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}
class AddOrRemoveProductFromCartLoading extends ProductDetailsState {}
class AddOrRemoveProductFromCartSuccess extends ProductDetailsState {}
class AddOrRemoveProductFromCartFailure extends ProductDetailsState {}