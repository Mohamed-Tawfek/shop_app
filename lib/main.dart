import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/cart_cubit/cart_cubit.dart';
import 'package:shop_app/cubits/category_cubit/category_cubit.dart';
import 'package:shop_app/cubits/home_screen_cubit/home_screen_cubit.dart';
import 'package:shop_app/cubits/login_cubit/login_cubit.dart';
import 'package:shop_app/cubits/product_details_cubit/product_details_cubit.dart';
import 'package:shop_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:shop_app/cubits/register_cubit/register_cubit.dart';
import 'package:shop_app/cubits/search_cubit/search_cubit.dart';
import 'package:shop_app/cubits/shop_layout_cubit/shop_layout_cubit.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'cubits/bloc_observer.dart';
import 'layout/shop_layout.dart';
import 'layout/onboarding_screen.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      DioHelper.init();
      await CashHelper.init();
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ShopLayoutCubit()),
          BlocProvider(create: (context) => SearchCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(create: (context) => ProfileCubit()..getProfileData()),
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => CartCubit()..getCartData()),
          BlocProvider(create: (context) => CategoryCubit()..getCategoriesData()),
          BlocProvider(create: (context) => HomeCubit()..getHomeData()),
          BlocProvider(create: (context) => ProductDetailsCubit()),

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping',
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                  color: Colors.white,
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  )),
              primarySwatch: primarySwatchColor,
              fontFamily: 'font_app'),
          home: getInitialScreen(),
        ));
  }
}

Widget getInitialScreen() {
  bool? onBoardingStatus = CashHelper.getData(key: 'onBoarding');
  String? token = CashHelper.getData(key: 'token');
  if (onBoardingStatus == null) {
    return OnBoardingScreen();
  } else if (token == null) {
    return const LoginScreen();
  } else {
    return const ShopLayout();
  }
}
