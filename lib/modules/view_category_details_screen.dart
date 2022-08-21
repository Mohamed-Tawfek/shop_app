import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';

import '../shared/component/component.dart';

class ViewCategoryDetailsScreen extends StatelessWidget {
  var id;
  ViewCategoryDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getCategoryDetails(id: id),
      child: BlocConsumer<CategoryCubit, CategoriesState>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(),
              body: ConditionalBuilder(
                  condition: CategoryCubit.get(context).categoryDetails != null,
                  builder: (context) => SingleChildScrollView(physics: const BouncingScrollPhysics(),
                    child: buildViewProductsUi(
                      forHomeScreen: false,
                        model: CategoryCubit.get(context)
                            .categoryDetails!
                            .categoryDetails,

                        context: context),
                  ),
                  fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ))),
          listener: (context, state) {}),
    );
  }
}
