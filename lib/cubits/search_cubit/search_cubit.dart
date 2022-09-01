import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:shop_app/cubits/search_cubit/search_state.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/search_model.dart';
import '../../shared/component/component.dart';
import '../../shared/network/local/cash_helper.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  SearchModel? searchModel;
  String token = CashHelper.getData(key: 'token');
  static SearchCubit get(context) => BlocProvider.of(context);
static  dynamic searchWord;
  search({required String searchKeyWord}) {
    searchWord=null;
    searchWord=searchKeyWord;
    searchModel = null;
    emit(GetSearchDataLoading());
    DioHelper.postData(
        endPoint: searchEndPoint,
        token: token,
        data: {'text': searchKeyWord}).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(GetSearchDataSuccess());
    }).catchError((onError) {
      emit(GetSearchDataError());
    });
  }

  Future<void> addOrDeleteFromCart(
      {required num productId,
      required int indexInProductModel,
      required context}) async {
    searchModel!.products[indexInProductModel].inCart =
        !searchModel!.products[indexInProductModel].inCart;

    emit(ChangeIconCartStateLoading());
    await DioHelper.postData(
            endPoint: addOrRemoveCartEndPoint,
            data: {'product_id': productId},
            token: token)
        .then((value) {
      if (searchModel!.products[indexInProductModel].inCart) {
        buildAlertToast(
            message: 'Added to Cart!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from Cart!', alertToast: AlertToast.success);
      }
      emit(ChangeIconCartSuccess());
      HomeCubit.get(context).getProductsData();
      CartCubit.get(context).getCartData();
      emit(ChangeIconCartSuccess());
    }).catchError((onError) {
      searchModel!.products[indexInProductModel].inCart =
          !searchModel!.products[indexInProductModel].inCart;
      emit(FailedChangeIconCartState());
    });
  }


  Future<void> addOrDeleteFavorite( {required num productId,
    required int indexInProductModel,required context})async {
    searchModel!.products[indexInProductModel].inFavorites =
    !searchModel!.products[indexInProductModel].inFavorites;
    emit(LoadingChangeIconFavorite());
    DioHelper.postData(endPoint: addOrRemoveFavoritesEndPoint, data: {'product_id': productId}, token: token).then((value) {
      if (searchModel!.products[indexInProductModel].inFavorites) {
        buildAlertToast(
            message: 'Added to favourites!', alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: 'Removed from favourites!',
            alertToast: AlertToast.success);
      }
      emit(SuccessChangeFavorite());
      HomeCubit.get(context).getProductsData();
      CartCubit.get(context).getCartData();

    }).catchError((onError) {
      searchModel!.products[indexInProductModel].inFavorites =
      !searchModel!.products[indexInProductModel].inFavorites;
      emit(FailedChangeFavorite());
      if (searchModel!.products[indexInProductModel].inFavorites) {
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



}
