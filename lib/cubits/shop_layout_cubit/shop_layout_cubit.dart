import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_state.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutState> {
  ShopLayoutCubit() : super(ShopLayoutInitial());
  static ShopLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndexOfBottomNav = 0;
  changeIndexOfBottomNav(int index) {
    currentIndexOfBottomNav = index;
    emit(ChangeBottomNavState());
  }
}
