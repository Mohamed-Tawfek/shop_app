import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_cubit.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_state.dart';
import 'package:shop_app/modules/category_screen.dart';
import 'package:shop_app/modules/home_screen.dart';
import '../cubits/home_screen_cubit/home_screen_state.dart';
import '../modules/cart_screen.dart';

class ShopLayout extends StatelessWidget {
  ShopLayout({Key? key}) : super(key: key);
  List<Widget> screensOfBottomNav = const [
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
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
            ),
            body: screensOfBottomNav[
                ShopLayoutCubit.get(context).currentIndexOfBottomNav],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: ShopLayoutCubit.get(context).currentIndexOfBottomNav,
              onTap: (int index) {
                ShopLayoutCubit.get(context).changeIndexOfBottomNav(index);
              },
              items: [
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
