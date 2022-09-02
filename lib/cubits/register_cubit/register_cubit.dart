import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/register_cubit/register_state.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/shared/component/component.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/user_model.dart';
import '../../shared/network/end_points.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;
  bool isLoadingForRegister = false;
  Future<void> register(
    context, {
    required name,
    required password,
    required email,
    required phone,
  }) async {
    isLoadingForRegister = true;
    emit(LoadingForRegisterState());

    await DioHelper.postData(endPoint: registerEndPoint, data: {
      'name': name,
      'password': password,
      'email': email,
      'phone': phone,
    }).then((value) async {
      userModel = UserModel.fromJson(value.data);
      if (userModel!.status == true) {
        await CashHelper.setData(key: 'token', value: userModel!.token);
        navigateToAndFinish(screen:const ShopLayout(), context: context);
        buildAlertToast(
            message: userModel!.message, alertToast: AlertToast.success);
      } else {
        buildAlertToast(
            message: userModel!.message, alertToast: AlertToast.error);
      }
      emit(SuccessInRegisterState());
    }).catchError((onError) {
      emit(ErrorInRegisterState());
    });
    isLoadingForRegister = false;
  }
}
