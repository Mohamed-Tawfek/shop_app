import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/component/component.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/cart_details_model.dart';
import '../../shared/network/end_points.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  static CartCubit get(context) => BlocProvider.of(context);
  CartDetailsModel? cartDetails;
  String token = CashHelper.getData(key: 'token');
  Future<void> getCartData() async {
    cartDetails = null;
    emit(CartDataLoadingState());
    DioHelper.getData(endPoint: cartEndPoint, token: token).then((value) {
      cartDetails = CartDetailsModel.fromJson(value.data);
      emit(CartDataSuccessState());
    }).catchError((onError) {
      emit(CartDataErrorState());
      debugPrint('There is an error in getCartData is $onError');
    });
  }

  Future<void> deleteFromCart({required num? productId}) async{
    DioHelper.postData(
            endPoint: addOrRemoveCartEndPoint,
            data: {'product_id': productId},
            token: token)
        .then((value) {
      getCartData().then((value) {
        buildAlertToast(
            message: 'Deleted successfully', alertToast: AlertToast.error);
        emit(DeleteFromCartSuccessState());
      });
    }).catchError((onError) {
      emit(DeleteFromCartErrorState());
    });
  }

  void deleteCart() async{
    // I had to loop on all items ,
    // because delete cart endpoint does not work!
    cartDetails!.items.forEach((element)async {
     await deleteFromCart(productId: element.product!.id);
    });


  }
}
