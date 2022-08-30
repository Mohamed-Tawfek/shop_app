import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';
import 'package:shop_app/modules/view_category_details_screen.dart';
import 'package:shop_app/shared/component/component.dart';
import '../models/category_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getCategoriesData(),
      child: BlocConsumer<CategoryCubit, CategoriesState>(
          builder: (context, state) {
            return Scaffold(
              body: ConditionalBuilder(
                  condition: CategoryCubit.get(context).categoryModel != null,
                  builder: (context) => ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildCategoryItem(
                            context: context,
                            model: CategoryCubit.get(context)
                                .categoryModel!
                                .data[index]),
                        separatorBuilder: (context, index) =>
                            buildSeparatorBuilderForCategoryItem(),
                        itemCount: CategoryCubit.get(context)
                            .categoryModel!
                            .data
                            .length,
                      ),
                  fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      )),
            );
          },
          listener: (context, state) {}),
    );
  }

  Widget buildCategoryItem({required CategoryDataModel model, context}) =>
      Padding(
        padding: const EdgeInsets.only(
          right: 15,
          left: 15,
        ),
        child: InkWell(
          onTap: () {
            navigateTo(
                screen: ViewCategoryDetailsScreen(id: model.id),
                context: context);
          },
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.network(
                    model.image.toString(),
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(model.name.toString(),
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  Widget buildSeparatorBuilderForCategoryItem() => Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 5, bottom: 5),
        child: Container(
          height: 1,
          color: Colors.grey[900],
        ),
      );
}
