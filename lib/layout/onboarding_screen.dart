import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/shared/component/constans.dart';
import 'package:shop_app/shared/network/local/cash_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../shared/styles/colors.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);
  List<OnBoardingModel> onBoardingItems = [
    OnBoardingModel(
        pathOfImage: 'assets/images/onboarding_images/1.jpg',
        screenBody: 'Screen Body 1',
        screenTitle: 'Screen Title 1'),
    OnBoardingModel(
        pathOfImage: 'assets/images/onboarding_images/2.jpg',
        screenBody: 'Screen Body 2',
        screenTitle: 'Screen Title 2'),
    OnBoardingModel(
        pathOfImage: 'assets/images/onboarding_images/3.jpg',
        screenBody: 'Screen Body 3',
        screenTitle: 'Screen Title 3'),
  ];
  final PageController _pageController = PageController();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed:(){
                  skipOnBoardingScreen(context);
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int index) {
                    if (index == onBoardingItems.length - 1) {
                      isLast = true;
                    } else {
                      isLast = false;
                    }
                  },
                  itemBuilder: (context, index) =>
                      buildOnBoardingItem(context, onBoardingItems[index]),
                  itemCount: onBoardingItems.length,
                ),
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: onBoardingItems.length,
                    effect: const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: primarySwatchColor),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        skipOnBoardingScreen(context);
                      } else {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buildOnBoardingItem(context, OnBoardingModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          model.pathOfImage,
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
        ),
        Text(
          model.screenTitle,
          style: const TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          model.screenBody,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void skipOnBoardingScreen(context) {
    CashHelper.setData(key: 'onBoarding', value: true).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight, child: LoginScreen()),
        (route) => false,
      );
    });
  }
}

class OnBoardingModel {
  OnBoardingModel(
      {required this.pathOfImage,
      required this.screenBody,
      required this.screenTitle});
  String pathOfImage;
  String screenBody;
  String screenTitle;
}
