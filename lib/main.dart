import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MaterialApp(
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
    );
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
