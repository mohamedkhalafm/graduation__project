// ignore: must_be_immutable
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/modules/Login_Screen/cubit/login_cubit.dart';
import 'package:graduation_project/modules/Login_Screen/cubit/login_states.dart';
import 'package:graduation_project/modules/ProfileScreen/ProfileCubit/profile_cubit.dart';
import 'package:graduation_project/modules/home_layout/home_layout.dart';
import 'package:graduation_project/modules/register_screen/register_screen.dart';
import 'package:graduation_project/network/local_network/Cache_Helper.dart';
import 'package:graduation_project/widgets/fade_animation.dart';

import '../../widgets/reusable_components.dart';
import '../ForgotPassword/forgotPassword_Screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.message == 'successfull login') {
              print(state.loginModel.message);
              print(state.loginModel.user?.token);
              ProfileCubit.get(context).getUserProfile();

              showToast(
                  text: state.loginModel.message!, state: ToastStates.SUCCESS);
              CacheHelper.saveData(key: 'token', value: true).then(
                (value) => navigateToAndBurn(
                  context,
                  HomeLayout(),
                ),
              );
            } else {
              print(state.loginModel.message);

              showToast(
                  text: 'Wrong Email or Password', state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(top: 50),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [firstColor, secondColor, thirdColor],
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeAnimation(
                          1,
                          Container(
                            height: 200,
                            width: 170,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/loginscreen.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: FadeAnimation(
                          1.6,
                          Row(
                            children: [
                              Container(
                                child: Text('Sign In ',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.8,
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: fourthColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  defaultFormField(
                                      context: context,
                                      controller: emailController,
                                      inputType: TextInputType.emailAddress,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return 'Email must not be null';
                                        }
                                        if (!value.endsWith('.com')) {
                                          return 'Invalid Email Address';
                                        }
                                      },
                                      label: 'Email Address',
                                      prefixIcon: Icons.email),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  defaultFormField(
                                    context: context,
                                    controller: passwordController,
                                    inputType: TextInputType.visiblePassword,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password must not be null';
                                      }
                                    },
                                    label: 'Password',
                                    prefixIcon: Icons.lock,
                                    suffixIcon:
                                        LoginCubit.get(context).passwordIcon,
                                    isPasswordShown:
                                        LoginCubit.get(context).isPasswordShown,
                                    onTapSuffixIcon: () =>
                                        LoginCubit.get(context).showPassword(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:  [
                                      TextButton(
                                        onPressed: () {
                                          navigateTo(context, ForgotPassword());
                                        },
                                        child: Text('Forget Password? ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FadeAnimation(
                                    2,
                                    Container(
                                      child: ConditionalBuilder(
                                          condition:
                                              state is! LoginLoadingState,
                                          builder: (context) => Container(
                                                child: defaultButton(
                                                    function: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        LoginCubit.get(context)
                                                            .userLogin(
                                                          email: emailController
                                                              .text,
                                                          password:
                                                              passwordController
                                                                  .text,
                                                        );
                                                      }
                                                    },
                                                    text: 'SIGN IN',
                                                    context: context),
                                              ),
                                          fallback: (ctx) => const Center(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/loading.gif'),
                                                  height: 90,
                                                  width: 90,
                                                ),
                                              )),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('don\'t have an account? ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          RegisterScreen()));
                                        },
                                        child: Text('Sign Up ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
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
