import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/banners_model.dart';
import 'package:shop_app/shared/component/component.dart';
import '../../models/products_model.dart';
import '../../shared/network/end_points.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/network/remote/dio_helper.dart';
import 'home_screen_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  ProductsModel? productModel;
  BannerDataModel? bannerDataModel;
  String token = CashHelper.getData(key: 'token');
  addOrDeleteFromCart(
      {required num productId, required int indexInProductModel}) {
    emit(ChangeIconCartState());
    productModel!.products[indexInProductModel].inCart =
        !productModel!.products[indexInProductModel].inCart;

    DioHelper.postData(
            endPoint: addOrRemoveCartEndPoint,
            data: {'product_id': productId},
            token: token)
        .then((value) {
      if (productModel!.products[indexInProductModel].inCart) {
        buildAlertToast(
            message: 'Added to Cart!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from Cart!', alertToast: AlertToast.success);
      }
    }).catchError((onError) {
      productModel!.products[indexInProductModel].inCart =
          !productModel!.products[indexInProductModel].inCart;
      emit(FailedChangeCartState());
    });
  }

  addOrDeleteFavorite(
      {required num productId, required int indexInProductModel}) {
    productModel!.products[indexInProductModel].inFavorites =
        !productModel!.products[indexInProductModel].inFavorites;
    emit(ChangeIconFavoriteState());
    DioHelper.postData(
            endPoint: addOrRemoveFavoritesEndPoint,
            data: {'product_id': productId},
            token: token)
        .then((value) {
      if (productModel!.products[indexInProductModel].inFavorites) {
        buildAlertToast(
            message: 'Added to favourites!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from favourites!',
            alertToast: AlertToast.success);
      }
    }).catchError((onError) {
      productModel!.products[indexInProductModel].inFavorites =
          !productModel!.products[indexInProductModel].inFavorites;
      emit(FailedChangeFavoriteState());
      if (productModel!.products[indexInProductModel].inFavorites) {
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

  Future<void> getHomeData() async {
    await getBannerData();
    await getProductsData();
  }

  Future<void> getBannerData() async {
    emit(GetBannersDataLoadingState());
    await DioHelper.getData(
      endPoint: bannersEndPoint,
    ).then((value) {
      bannerDataModel = BannerDataModel.fromJson(value.data);
      emit(GetBannersDataSuccessState());
    }).catchError((onError) {
      emit(GetBannersDataErrorState());
      debugPrint("Error when getBannerData is :$onError");
    });
  }

  Future<void> getProductsData() async {
    emit(GetProductsDataLoadingState());
    await DioHelper.getData(endPoint: homeEndPoint, token: token).then((value) {
      productModel = ProductsModel.fromJson(value.data);
      emit(GetProductsDataSuccessState());
    }).catchError((onError) {
      emit(GetProductsDataErrorState());
      debugPrint("Error when getHomeData is :$onError");
    });
  }
}
