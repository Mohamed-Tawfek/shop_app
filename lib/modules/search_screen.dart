import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/search_cubit/search_cubit.dart';
import 'package:shop_app/shared/component/component.dart';

import '../cubits/search_cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultTextField(
                      controller: searchController,
                      validator: (data) {
                        return null;
                      },
                      labelText: 'type here to search',
                      onChanged: (word) {
                        SearchCubit.get(context).search(searchKeyWord: word);
                      }),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: ConditionalBuilder(
                      condition: SearchCubit.get(context).searchModel != null,
                      builder: (context) => ConditionalBuilder(
                          condition: SearchCubit.get(context)
                              .searchModel!
                              .products
                              .isNotEmpty,
                          builder: (context) => SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: buildViewProductsUi(
                                    model: SearchCubit.get(context)
                                        .searchModel!
                                        .products,
                                    context: context),
                              ),
                          fallback: (context) => const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Center(
                                  child: Text(
                                    'no products found!',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                      fallback: (context) => state is GetSearchDataLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Center(
                                child: Text(
                                  'type To search!',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
