import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/search_cubit/search_state.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../models/search_model.dart';
import '../../shared/network/local/cash_helper.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  SearchModel? searchModel;
  String token = CashHelper.getData(key: 'token');
  static SearchCubit get(context) => BlocProvider.of(context);
  search({required String searchKeyWord}) {
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
}
