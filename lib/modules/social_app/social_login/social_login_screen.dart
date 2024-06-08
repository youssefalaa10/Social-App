import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_app/social_layout.dart';
import 'package:social/modules/social_app/social_login/cubit/cubit.dart';
import 'package:social/modules/social_app/social_login/cubit/states.dart';
import 'package:social/modules/social_app/social_register/social_register_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cache_helper.dart';

class SocialLoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.error,
            );
          }
          if(state is SocialLoginSuccessState)
            {
              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                  context,
                  const SocialLayout(),
                );
              });
            }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                      Text(
                        'login now to communicate with friends',
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          // Add additional validation rules if needed
                          return null; // Return null if validation passes
                        },
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffix: SocialLoginCubit.get(context).suffix,
                        onSubmit: (value) {
                          if (formKey.currentState!.validate()) {
                            SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text
                            );
                          }
                        },
                        isPassword: SocialLoginCubit.get(context).isPassword,
                        suffixPressed: () {
                          SocialLoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        validate: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is too short';
                          }
                          // Add additional validation logic if needed
                          return null; // Return null if validation passes
                        },
                        label: 'Password',
                        prefix: Icons.lock_outline,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                            }
                          },
                          text: 'login',
                          isUpperCase: true,
                        ),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an Account ?'),
                          defaultButton(
                            function: () {
                              navigateTo(
                                context,
                                SocialRegisterScreen(),
                              );
                            },
                            text: 'register',
                          ),
                        ],
                      ),
                    ],
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
