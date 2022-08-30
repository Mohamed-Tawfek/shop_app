import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:shop_app/cubits/profile_cubit/profile_state.dart';
import 'package:shop_app/shared/component/component.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ProfileCubit()..getProfileData(),
        child:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (ProfileCubit.get(context).profileModel != null) {
            nameController.text = ProfileCubit.get(context).profileModel!.name;

            emailController.text =
                ProfileCubit.get(context).profileModel!.email;
            phoneController.text =
                ProfileCubit.get(context).profileModel!.phone;
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: ConditionalBuilder(
                  condition: ProfileCubit.get(context).profileModel != null,
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: BuildProfileUi(
                            nameController: nameController,
                            emailController: emailController,
                            phoneController: phoneController),
                      ),
                  fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      )));
        }));
  }
}

class BuildProfileUi extends StatefulWidget {
  BuildProfileUi({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();
  @override
  State<BuildProfileUi> createState() => _BuildProfileUiState();
}

class _BuildProfileUiState extends State<BuildProfileUi> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              defaultTextField(
                controller: widget.nameController,
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return 'must not be empty';
                  }
                  return null;
                },
                labelText: 'Name',
                enabled: ProfileCubit.get(context).textFormIsEnable,
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultTextField(
                controller: widget.emailController,
                enabled: ProfileCubit.get(context).textFormIsEnable,
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return 'must not be empty';
                  }
                  return null;
                },
                labelText: 'Email',
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultTextField(
                controller: widget.phoneController,
                enabled: ProfileCubit.get(context).textFormIsEnable,
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return 'must not be empty';
                  }
                  return null;
                },
                labelText: 'Phone',
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultTextField(
                controller: widget.passwordController,
                enabled: ProfileCubit.get(context).textFormIsEnable,
                validator: (String? data) {
                  return null;
                },
                labelText: 'To Change Password , write here a new password',
              ),
              const SizedBox(
                height: 30.0,
              ),
              if (!ProfileCubit.get(context).textFormIsEnable)
                defaultMaterialButton(context, text: 'Edit',
                    onPressedButton: () {
                  setState(() {
                    ProfileCubit.get(context).textFormIsEnable = true;
                  });
                })
              else
                defaultMaterialButton(context, text: 'Save',
                    onPressedButton: () {
                  if (widget.formKey.currentState!.validate()) {
                    ProfileCubit.get(context).updateProfile(
                        email: widget.emailController.text,
                        name: widget.nameController.text,
                        phone: widget.phoneController.text,
                        password: widget.passwordController.text);
                    ProfileCubit.get(context).textFormIsEnable = false;
                  }
                }),
              const SizedBox(
                height: 20.0,
              ),
              if (ProfileCubit.get(context).textFormIsEnable)
                defaultMaterialButton(context, text: 'Cancel',
                    onPressedButton: () {
                  setState(() {
                    ProfileCubit.get(context).textFormIsEnable = false;
                  });
                }),
              if (ProfileCubit.get(context).textFormIsEnable)
                const SizedBox(
                  height: 20.0,
                ),
              if (!ProfileCubit.get(context).textFormIsEnable)
                defaultMaterialButton(context, text: 'Logout',
                    onPressedButton: () {
                  ProfileCubit.get(context).logout(context);
                })
            ],
          ),
        ),
      ),
    );
  }
}
