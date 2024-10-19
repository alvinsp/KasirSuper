import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/settings/blocs/profile/profile_bloc.dart';
import 'package:kasirsuper/features/settings/pages/pages.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/auth/register';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == Status.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful!')),
              );
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            } else if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Registration failed!')),
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
                          'Create Your Account',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Dimens.dp20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Dimens.dp40.height,
                        // Name TextField
                        RegularTextInput(
                          controller: nameController,
                          label: "Nama Toko",
                          hintText: 'Toko Alvin',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp14,
                          ),
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.person,
                        ),
                        Dimens.dp16.height,
                        // Email TextField
                        RegularTextInput(
                          controller: emailController,
                          label: "Email",
                          hintText: 'alvin@gmail.com',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        Dimens.dp16.height,
                        // Phone Number TextField
                        RegularTextInput(
                          label: "Phone Number",
                          controller: phoneNumberController,
                          hintText: '0899324578',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp14,
                          ),
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        Dimens.dp16.height,
                        // Password TextField
                        RegularTextInput(
                          controller: passwordController,
                          label: "Password",
                          hintText: '',
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp14,
                          ),
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          maxLines: 1,
                          obscureText: true,
                        ),
                        Dimens.dp16.height,
                        // Confirm Password TextField
                        RegularTextInput(
                          controller: confirmPasswordController,
                          label: "Confirm Password",
                          hintText: '',
                          maxLines: 1,
                          obscureText: true,
                          hintStyle: const TextStyle(
                            fontSize: Dimens.dp14,
                          ),
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                        ),
                        Dimens.dp40.height,
                        // Register Button
                        SizedBox(
                          width: double.infinity, // Make button fill the width
                          child: ElevatedButton(
                            onPressed: state.status == Status.loading
                                ? null
                                : () {
                                    if (passwordController.text.trim() !=
                                        confirmPasswordController.text.trim()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Passwords do not match!')),
                                      );
                                      return;
                                    }
                                    BlocProvider.of<ProfileBloc>(context).add(
                                      SubmitProfileEvent(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        phoneNumber:
                                            phoneNumberController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        confirmPassword:
                                            confirmPasswordController.text
                                                .trim(),
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
                              ),
                            ),
                            child: state.status == Status.loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        Dimens.dp16.height,
                        // Navigate to Login
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, LoginPage.routeName, (route) => false);
                          },
                          child: const Text(
                            'Already have an account? Login here!',
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
