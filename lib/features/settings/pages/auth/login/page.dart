import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/home/home.dart';
import 'package:kasirsuper/features/settings/blocs/profile/profile_bloc.dart';
import 'package:kasirsuper/features/settings/pages/pages.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/auth/login';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
              );
              Navigator.pushReplacementNamed(context, MainPage.routeName);
            } else if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Login failed!')),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        // App Logo
                        Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                        ),
                        Dimens.dp20.height,
                        // Title
                        const Text(
                          'Login to Your Account',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimens.dp20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Dimens.dp40.height,
                        // Email TextField
                        RegularTextInput(
                          controller: emailController,
                          label: "Email",
                          hintText: 'alvin@gmail.com',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp16,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        Dimens.dp16.height,
                        // Password TextField
                        RegularTextInput(
                          controller: passwordController,
                          label: "Password",
                          hintText: '',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp16,
                          ),
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                        ),
                        Dimens.dp40.height,

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.status == Status.loading
                                ? null
                                : () {
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      LoginEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.white,
                              backgroundColor: const Color(0XFF2cbe79),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: Dimens.dp12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ), // Text color
                            ),
                            child: state.status == Status.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        Dimens.dp16.height,
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RegisterPage.routeName, (route) => false);
                          },
                          child: const Text(
                            'Don\'t have an account? Register here!',
                            style: TextStyle(color: AppColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
