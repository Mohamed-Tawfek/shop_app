import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';

import 'package:shop_app/models/products_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../cubits/product_details_cubit/product_details_cubit.dart';
import '../shared/component/component.dart';
import '../shared/styles/colors.dart';

class ProductViewScreen extends StatelessWidget {
  ProductViewScreen({
    Key? key,
    required this.model,
    required this.index,
    required this.idOfCategory,
    this.forSearch=false
  }) : super(key: key);
  ProductModel?  model;
  int index;
  PageController pageController = PageController();
  bool isLast = false;
  bool isFirst = true;
  var idOfCategory;
  bool forSearch;
  @override
  Widget build(BuildContext context) {
    ProductDetailsCubit.inCart=model!.inCart;

    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
  builder: (context, state) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_outlined),
        onPressed: () {
          Navigator.pop(context);


        },

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    PageView(
                      physics: const BouncingScrollPhysics(),
                      controller: pageController,
                      onPageChanged: (index) {
                        if (index != 0) {
                          isFirst = false;
                        } else {
                          isFirst = true;
                        }
                        if (index == model!.otherImages.length - 1) {
                          isLast = true;
                        } else {
                          isLast = false;
                        }
                      },
                      children: model!.otherImages
                          .map((e) => Image.network(
                                e,
                                fit: BoxFit.contain,
                              ))
                          .toList(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (isFirst) {
                              pageController
                                  .jumpToPage(model!.otherImages.length - 1);
                            } else {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 750),
                                  curve: Curves.fastLinearToSlowEaseIn);
                            }
                          },
                          icon: const Icon(Icons.arrow_back_ios_outlined),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.fastLinearToSlowEaseIn);
                            if (isLast) {
                              pageController.jumpToPage(0);
                            }
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    )
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: SmoothPageIndicator(
              controller: pageController,
              count: model!.otherImages.length,
              effect: const ExpandingDotsEffect(
                  activeDotColor: primarySwatchColor, dotColor: Colors.grey),
            )),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                Expanded(
                  child: Text(
                    model!.name,
                    style: const TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Price :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${model!.price} EGP ",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primarySwatchColor,
                      fontSize: 30),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (model!.discount!=null&&model!.discount>0)
                  Expanded(
                    child: Text(
                      "${model!.oldPrice} EGP",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 25),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Description : ',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              model!.description.toString(),
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
        state is AddOrRemoveProductFromCartLoading?
            const Center(child: CircularProgressIndicator(),):


        defaultMaterialButton(
          context,
          onPressedButton: ()  {
               ProductDetailsCubit.get(context).addOrRemoveFromCart(
              context: context, productId: model!.id,
                 categoryId: idOfCategory,
                 useInSearch: forSearch
            );


          },
          text:  ProductDetailsCubit.inCart ?'Removed from cart':'Add to cart',
          color: Colors.amber,
        ),
            const SizedBox(
              height: 10.0,
            ),

          ],
        ),
      ),
    );
  },
);
  }
}
