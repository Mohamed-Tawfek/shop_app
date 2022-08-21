import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/category_details_model.dart';
import '../../models/products_model.dart';
import '../../shared/component/component.dart';
import '../../shared/network/end_points.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoriesState> {
  CategoryCubit() : super(CategoriesInitial());

  static CategoryCubit get(context) => BlocProvider.of(context);
  CategoryModel? categoryModel;
  CategoryDetailsModel? categoryDetails;
  String token = CashHelper.getData(key: 'token');
  addOrDeleteFromCart(
      {required num productId, required int indexInProductModel}) {
    emit(ChangeIconCartState());
    categoryDetails!.categoryDetails[indexInProductModel].inCart=
    !categoryDetails!.categoryDetails[indexInProductModel].inCart;

    DioHelper.postData(
        endPoint: addOrRemoveCartEndPoint,
        data: {'product_id': productId},
        token: token).then((value) {
      if (categoryDetails!.categoryDetails[indexInProductModel].inCart) {
        buildAlertToast(
            message: 'Added to Cart!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from Cart!',
            alertToast: AlertToast.success);
      }
    }).catchError((onError){
      categoryDetails!.categoryDetails[indexInProductModel].inCart =
      !categoryDetails!.categoryDetails[indexInProductModel].inCart;
      emit(FailedChangeCartState());
    });
  }

  addOrDeleteFavorite(
      {required num productId, required int indexInProductModel}) {
    categoryDetails!.categoryDetails[indexInProductModel].inFavorites =
    !categoryDetails!.categoryDetails[indexInProductModel].inFavorites;
    emit(ChangeIconFavoriteState());
    DioHelper.postData(
        endPoint: addOrRemoveFavoritesEndPoint,
        data: {'product_id': productId},
        token: token)
        .then((value) {
      if (categoryDetails!.categoryDetails[indexInProductModel].inFavorites) {
        buildAlertToast(
            message: 'Added to favourites!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from favourites!',
            alertToast: AlertToast.success);
      }
    }).catchError((onError) {
      categoryDetails!.categoryDetails[indexInProductModel].inFavorites =
      !categoryDetails!.categoryDetails[indexInProductModel].inFavorites;
      emit(FailedChangeFavoriteState());
      if (categoryDetails!.categoryDetails[indexInProductModel].inFavorites) {
        buildAlertToast(
            message: 'Error in removing from favourites!',
            alertToast: AlertToast.error);
      } else {
        buildAlertToast(
            message: 'Error adding to favourites!',
            alertToast: AlertToast.error);
      }
    });
  }
  void getCategoriesData() {
    emit(LoadingCategoriesData());
    DioHelper.getData(endPoint: categoriesEndPoint).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      emit(SuccessInGetCategoriesData());
    }).catchError((onError) {
      emit(ErrorInGetCategoriesData());
      debugPrint("The Error when getCategoryData is : $onError");
    });
  }

  void getCategoryDetails({required id}) {
    categoryDetails = null;
    emit(LoadingCategoryDetails());
    DioHelper.getData(endPoint: '$categoriesEndPoint/$id',
    token: token
    ).then((value) {
      categoryDetails = CategoryDetailsModel.fromJson(value.data);
      emit(SuccessInGetCategoryDetails());
    }).catchError((onError) {
      emit(ErrorInGetCategoryDetails());
      debugPrint("The Error when getCategoryDetails is : $onError");
    });
  }
}
