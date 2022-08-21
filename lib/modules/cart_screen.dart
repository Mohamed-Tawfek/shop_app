import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/product_view_screen.dart';
import 'package:shop_app/shared/styles/colors.dart';

import '../cubits/cart_cubit/cart_cubit.dart';
import '../cubits/cart_cubit/cart_state.dart';
import '../models/cart_details_model.dart';
import '../shared/component/component.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..getCartData(),
      child: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: ConditionalBuilder(
                condition: CartCubit.get(context).cartDetails != null,
                builder: (context) => ConditionalBuilder(
                    condition:
                        CartCubit.get(context).cartDetails!.items.isNotEmpty,
                    builder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      buildCartItems(
                                          model: CartCubit.get(context)
                                              .cartDetails!
                                              .items[index],
                                          context: context),
                                  separatorBuilder: (context, index) =>
                                      Container(
                                        height: 1,
                                        color: Colors.grey[300],
                                      ),
                                  itemCount: CartCubit.get(context)
                                      .cartDetails!
                                      .items
                                      .length),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Total : ${CartCubit.get(context).cartDetails!.total} EG",
                                    style: TextStyle(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      CartCubit.get(context).deleteCart();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30.0,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                    fallback: (context) => Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(
                                fontSize: 35.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                fallback: (context) => Center(
                      child: CircularProgressIndicator(),
                    )),
          );
        },
      ),
    );
  }

  Widget buildCartItems({required CartItemsModel? model, required context}) =>
      InkWell(
        onTap: () {
          navigateTo(
              screen: ProductViewScreen(
                model: model!.product,

              ),
              context: context);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.network(
                model!.product!.mainImage,
                width: 120,
                height: 120,
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.product!.name,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          model.product!.price.toString(),
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: primarySwatchColor),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (model.product!.discount > 0)
                          Text(
                            model.product!.oldPrice.toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[300]),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              IconButton(
                onPressed: () {
                  CartCubit.get(context).deleteFromCart(
                    productId: model.product!.id,
                  );
                },
                icon: Icon(
                  Icons.delete,
                  size: 30.0,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      );
}
