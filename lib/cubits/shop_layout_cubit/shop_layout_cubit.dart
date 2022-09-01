import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_state.dart';

import '../home_screen_cubit/home_screen_cubit.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutState> {
  ShopLayoutCubit() : super(ShopLayoutInitial());
  static ShopLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndexOfBottomNav = 0;
  changeIndexOfBottomNav(int index,context) {
    currentIndexOfBottomNav = index;
    if(index==2){
      HomeCubit.get(context).productModel=null;
      CartCubit.get(context).getCartData();

    }
    if(index==0){

      HomeCubit.get(context).getHomeData();
    }
    emit(ChangeBottomNavState());
  }
}
