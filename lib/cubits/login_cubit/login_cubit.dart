import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import '../../shared/component/component.dart';
import '../../shared/network/end_points.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool progressStatus = false;
  LoginModel? loginModel;
  loginUser({required String email, required String password,required context}) {
    progressStatus = true;
    emit(LoginLoadingState());
    DioHelper.postData(
        endPoint: loginEndPoint,
        data: {'email': email, 'password': password}).then((value) {
      emit(LoginSuccessState());
      progressStatus = false;
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel!.status) {
        CashHelper.setData(key: 'token', value: loginModel!.token)
            .then((value) {
          navigateToAndFinish(screen:  ShopLayout(), context: context);
          buildAlertToast(
              alertToast: AlertToast.success, message: loginModel!.message);
        });

      } else {
        buildAlertToast(
            alertToast: AlertToast.error, message: loginModel!.message);
      }
    }).catchError((onError) {
      emit(LoginErrorState());
      progressStatus = false;
      if (kDebugMode) {
        print('There is an error when Login User is : $onError');
      }
      buildAlertToast(
          alertToast: AlertToast.error, message: loginModel!.message);
    });
  }
}
