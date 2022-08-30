import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_app/cubits/login_cubit/login_cubit.dart';
import 'package:shop_app/cubits/login_cubit/login_state.dart';
import 'package:shop_app/modules/register_screen.dart';

import '../shared/component/component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool obscureText = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: LoginCubit.get(context).progressStatus,
            child: Form(
              key: formKey,
              child: Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 50.0),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Text(
                            'login now to browse our hot offers',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 45.0,
                          ),
                          defaultTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Email must not be Empty';
                              }
                              if (!value.contains('@')) {
                                return 'Email must contain @';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              onFieldSubmitted: (v) {
                                loginUserWithValidation(context);
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Password must not be Empty';
                                }
                                if (value.length < 6) {
                                  return 'The password must not be less than 6 characters';
                                }
                                return null;
                              },
                              obscureText: obscureText,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  icon: Icon(obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultMaterialButton(context, text: 'login',
                              onPressedButton: () {
                            loginUserWithValidation(context);
                          }),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              defaultTextButton(
                                  onPressedText: () {
                                    navigateTo(
                                        screen: RegisterScreen(),
                                        context: context);
                                  },
                                  text: 'Register')
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void loginUserWithValidation(contextOfCubit) {
    if (formKey.currentState!.validate()) {
      LoginCubit.get(contextOfCubit).loginUser(
          email: _emailController.text,
          password: _passwordController.text,
          context: context);
    }
  }
}
