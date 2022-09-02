import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/profile_cubit/profile_state.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/shared/component/component.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import '../../models/profile_models.dart';
import '../../shared/network/local/cash_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);
  ProfileModel? profileModel;
  String token = CashHelper.getData(key: 'token');
  bool textFormIsEnable = false;
  getProfileData() {
    profileModel = null;
    emit(GetProfileDataLoading());
    DioHelper.getData(endPoint: getProfileEndPoint, token: token).then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      emit(GetProfileDataSuccess());
    }).catchError((onError) {
      emit(GetProfileDataError());
    });
  }

  updateProfile(
      {required name,
      required phone,
      required email,
      required password,
      required}) {
    emit(UpdateProfileDataLoading());
    DioHelper.putData(url: updateProfileEndPoint, token: token, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    }).then((value) {
      buildAlertToast(
          message: value.data['message'],
          alertToast: value.data['status'] == true
              ? AlertToast.success
              : AlertToast.error);
    }).then((value) async {
      await getProfileData();
      emit(UpdateProfileDataSuccess());
    }).catchError((onError) {
      emit(UpdateProfileDataError());
    });
  }

  logout(context) {
    DioHelper.postData(endPoint: logoutProfileEndPoint, token: token)
        .then((value) async {
      buildAlertToast(
          message: value.data['message'],
          alertToast: value.data['status'] == true
              ? AlertToast.success
              : AlertToast.error);
      await CashHelper.remove(key: 'token');
      navigateToAndFinish(screen:const LoginScreen(), context: context);
    });
  }
}
