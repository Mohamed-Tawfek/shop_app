import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shop_app/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_app/modules/product_view_screen.dart';
import '../../cubits/category_cubit/category_cubit.dart';
import '../../cubits/home_screen_cubit/home_screen_cubit.dart';
import '../../cubits/search_cubit/search_cubit.dart';
import '../../models/products_model.dart';
import '../styles/colors.dart';

Widget defaultTextField(
        {required TextEditingController controller,
        void Function(String)? onChanged,
        void Function(String)? onFieldSubmitted,
        bool enabled = true,
        required String? Function(String?)? validator,
        required String labelText,
        bool obscureText = false,
        Widget? prefixIcon,
        Widget? suffixIcon,
        TextInputType? keyboardType}) =>
    TextFormField(
      style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          label: Text(labelText),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
Widget defaultMaterialButton(context,
        {required onPressedButton,
        required String text,
        Color color = primarySwatchColor}) =>
    SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: MaterialButton(
        onPressed: onPressedButton,
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
Widget defaultTextButton(
        {required String text, required void Function()? onPressedText}) =>
    TextButton(
        onPressed: onPressedText,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ));

navigateTo({required Widget screen, required context}) => Navigator.push(
      context,
      PageTransition(type: PageTransitionType.leftToRight, child: screen),
    );

navigateToAndFinish({required Widget screen, required context}) =>
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(type: PageTransitionType.leftToRight, child: screen),
      (route) => false,
    );

enum AlertToast { success, error }

Future<bool?> buildAlertToast(
    {required String message, required AlertToast alertToast}) async {
  MaterialColor colorOfToast = Colors.green;
  if (alertToast == AlertToast.error) {
    colorOfToast = Colors.red;
  }

  return await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorOfToast,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget buildViewProductsUi(
    {required List<ProductModel> model,
    required context,
      required idOfCategory,
    bool forHomeScreen = false,
      bool forSearchScreen=false
    }) {
  return Container(
    color: Colors.grey[300],
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 3,
      // top is opposite in childAspectRatio
      childAspectRatio: 0.982 / 1.7,
      mainAxisSpacing: 3,
      children: List.generate(
          model.length,
          (index) => buildProductItemUi(model[index], context, index,
              idOfCategory:idOfCategory,
              forHomeScreen: forHomeScreen,
          forSearchScreen:  forSearchScreen
          )),
    ),
  );
}

Widget buildProductItemUi(ProductModel model, context, index,
    { required bool forHomeScreen ,  required idOfCategory, required bool forSearchScreen,}) {
  return InkWell(
    onTap: () {
      navigateTo(
          screen: ProductViewScreen(
            model: model,
            index: index,
            idOfCategory: idOfCategory,
            forSearch:forSearchScreen ,
          ),
          context: context);
    },
    child: Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.network(
                model.mainImage,
                height: 200.0,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Discount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 3.0,
                ),
                Text(
                  model.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      '${model.price.round()} EGP ',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primarySwatchColor),
                    ),
                    if (model.discount != 0 && model.discount != null)
                      Text(
                        '${model.oldPrice.round()} EGP ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (forHomeScreen) {
                          HomeCubit.get(context).addOrDeleteFromCart(
                              productId: model.id, indexInProductModel: index);
                        }
                        else if(forSearchScreen){
                          SearchCubit.get(context).addOrDeleteFromCart(
                            context: context,
                              productId: model.id, indexInProductModel: index);
                        }

                        else {
                          CategoryCubit.get(context).addOrDeleteFromCart(
                              productId: model.id, indexInProductModel: index);
                        }
                        CartCubit.get(context).getCartData();
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey[300]!.withOpacity(0.7),
                        child: Icon(
                          model.inCart == false
                              ? Icons.add_shopping_cart
                              : Icons.done,
                          color: primarySwatchColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (forHomeScreen) {
                          HomeCubit.get(context).addOrDeleteFavorite(
                              productId: model.id, indexInProductModel: index);
                        }
                        else if(forSearchScreen){
                          SearchCubit.get(context).addOrDeleteFavorite(
                              context: context,
                              productId: model.id, indexInProductModel: index);
                        }
                        else {
                          CategoryCubit.get(context).addOrDeleteFavorite(
                              productId: model.id, indexInProductModel: index);
                        }
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey[300]!.withOpacity(0.7),
                        child: Icon(model.inFavorites == true
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
