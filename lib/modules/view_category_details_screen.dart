import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';

import '../shared/component/component.dart';

class ViewCategoryDetailsScreen extends StatelessWidget {
   ViewCategoryDetailsScreen({Key? key,required this.id }) : super(key: key);
int? id;
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CategoryCubit, CategoriesState>(
        builder: (context, state) {



          return Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
                condition: CategoryCubit.get(context).categoryDetails != null,
                builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: buildViewProductsUi(
                          forHomeScreen: false,
                          model: CategoryCubit.get(context)
                              .categoryDetails!
                              .categoryDetails,
                          idOfCategory: id,
                          context: context),
                    ),
                fallback: (context) {
                   return const Center(
                    child: CircularProgressIndicator(),
                  );

                }));
        },
        listener: (context, state) {});
  }
}
