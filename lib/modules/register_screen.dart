import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_app/cubits/register_cubit/register_cubit.dart';
import 'package:shop_app/cubits/register_cubit/register_state.dart';
import 'package:shop_app/shared/component/component.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: RegisterCubit.get(context).isLoadingForRegister,
            child: Scaffold(
              appBar: AppBar(),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register'.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 50.0),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          'Register to browse our hot offers',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 45.0,
                        ),
                        defaultTextField(
                            controller: nameController,
                            validator: (String? data) {
                              if (data!.isEmpty) {
                                return 'must not be empty';
                              }
                              return null;
                            },
                            labelText: 'name'),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            validator: (String? data) {
                              if (data!.isEmpty) {
                                return 'must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Phone'),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String? data) {
                              final emailRegex = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                              if (!emailRegex.hasMatch(data!)) {
                                return 'Please enter a correct email';
                              }

                              return null;
                            },
                            labelText: 'Email'),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                            controller: passwordController,
                            validator: (String? data) {
                              if (data!.isEmpty) {
                                return 'must not be empty';
                              }
                              return null;
                            },
                            labelText: 'Password'),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultMaterialButton(context, onPressedButton: () {
                          if (_formKey.currentState!.validate()) {
                            RegisterCubit.get(context).register(context,
                                password: passwordController.text,
                                phone: phoneController.text,
                                name: nameController.text,
                                email: emailController.text);
                          }
                        }, text: 'Register')
                      ],
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
}
