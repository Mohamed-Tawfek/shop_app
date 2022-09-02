import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:shop_app/cubits/search_cubit/search_cubit.dart';

import '../../shared/network/end_points.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../cart_cubit/cart_cubit.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());
 
  static ProductDetailsCubit get(context)=>BlocProvider.of(context);
  String token = CashHelper.getData(key: 'token');
static bool inCart=false;
 Future<void> addOrRemoveFromCart({required context,required productId,required categoryId ,bool useInSearch=false})async{
 emit(AddOrRemoveProductFromCartLoading());

 DioHelper.postData(
     endPoint: addOrRemoveCartEndPoint,
     data: {'product_id': productId},
     token: token)
     .then((value) {
   inCart=! inCart;
    emit(AddOrRemoveProductFromCartSuccess());
if(useInSearch){
  SearchCubit.get(context).search(searchKeyWord: SearchCubit.searchWord);

}
    CategoryCubit.get(context).getCategoryDetails(id: categoryId);
   HomeCubit.get(context).getProductsData();
   CartCubit.get(context).getCartData();
 }).catchError((onError) {

   emit(AddOrRemoveProductFromCartFailure());

 });

    
  }
}
