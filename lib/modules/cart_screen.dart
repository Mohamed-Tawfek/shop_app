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
    return BlocConsumer<CartCubit, CartState>(
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
                                      index: index,
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
                                  style: const TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    CartCubit.get(context).deleteCart();
                                  },
                                  icon: const Icon(
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
                  fallback: (context) => const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.bold),
                        ),
                      )),
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  )),
        );
      },
    );
  }

  Widget buildCartItems({required CartItemsModel? model, required context,required index}) =>
      InkWell(
        onTap: () {
          navigateTo(
              screen: ProductViewScreen(
                model: model!.product,
idOfCategory: null,
index: index,
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
              const SizedBox(
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
                      style: const TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          model.product!.price.toString(),
                          style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: primarySwatchColor),
                        ),
                        const SizedBox(
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
              const SizedBox(
                width: 2.0,
              ),
              IconButton(
                onPressed: () {
                  CartCubit.get(context).deleteFromCart(
                    productId: model.product!.id,

                  );
                },
                icon: const Icon(
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
