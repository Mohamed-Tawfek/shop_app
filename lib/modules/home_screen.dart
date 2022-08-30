import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';
import '../cubits/home_screen_cubit/home_screen_state.dart';
import '../shared/component/component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(),
      child: BlocConsumer<HomeCubit, HomeStates>(
          builder: (context, state) {
            return ConditionalBuilder(
                condition: HomeCubit.get(context).productModel != null &&
                    HomeCubit.get(context).bannerDataModel != null,
                builder: (context) => RefreshIndicator(
                      onRefresh: () {
                        return HomeCubit.get(context)
                            .getHomeData()
                            .then((value) {
                          buildAlertToast(
                              alertToast: AlertToast.success,
                              message: 'Updated successfully');
                        }).catchError((onError) {
                          buildAlertToast(
                              alertToast: AlertToast.error,
                              message: 'There is an error');
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: CarouselSlider(
                                    items: List.generate(
                                        HomeCubit.get(context)
                                            .bannerDataModel!
                                            .banners
                                            .length,
                                        (index) => Image.network(
                                              HomeCubit.get(context)
                                                  .bannerDataModel!
                                                  .banners[index]
                                                  .image,
                                              fit: BoxFit.cover,
                                            )),
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      viewportFraction: 1,
                                    )),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              buildViewProductsUi(
                                  model: HomeCubit.get(context)
                                      .productModel!
                                      .products,
                                  context: context)
                            ],
                          ),
                        ),
                      ),
                    ),
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()));
          },
          listener: (context, state) {}),
    );
  }
}
