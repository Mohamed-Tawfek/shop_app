import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_cubit.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_state.dart';
import 'package:shop_app/modules/category_screen.dart';
import 'package:shop_app/modules/home_screen.dart';
import 'package:shop_app/modules/profile_screen.dart';
import '../modules/cart_screen.dart';
import '../modules/search_screen.dart';
import '../shared/component/component.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);
  final List<Widget> screensOfBottomNav = const [
    HomeScreen(),
    CategoryScreen(),
    CartScreen()
  ];
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ShopLayoutCubit(),
      child: BlocConsumer<ShopLayoutCubit, ShopLayoutState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Shopping',
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context: context, screen: SearchScreen());
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      navigateTo(context: context, screen: ProfileScreen());
                    },
                    icon: const Icon(Icons.person)),
              ],
            ),
            body: screensOfBottomNav[
                ShopLayoutCubit.get(context).currentIndexOfBottomNav],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:
                  ShopLayoutCubit.get(context).currentIndexOfBottomNav,
              onTap: (int index) {
                ShopLayoutCubit.get(context).changeIndexOfBottomNav(index,context);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.category_rounded), label: 'Category'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Cart'),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
