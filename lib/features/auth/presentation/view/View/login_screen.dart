import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_event.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_state.dart';
import 'package:kalamkart_mobileapp/features/auth/presentation/view_model/login_viewmodel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool? isPasswordValid;
  bool isPasswordVisible = false;

  void validateFormOnLogin() {
    setState(() {
      emailError = null;
      passwordError = null;

      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
        emailError = 'Enter a valid email';
      }

      if (password.length != 6) {
        passwordError = 'Password must be 6 digits';
        isPasswordValid = false;
      } else {
        passwordError = null;
        isPasswordValid = true;
      }
    });
  }

  void onLoginPressed() {
    validateFormOnLogin();

    if (emailError == null && isPasswordValid == true) {
      final email = emailController.text.trim();
      final password = passwordController.text;

      BlocProvider.of<LoginViewModel>(context).add(
        LoginSubmitted(email, password),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fix errors"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void resetValidation() {
    setState(() {
      emailError = null;
      passwordError = null;
      isPasswordValid = null;
    });
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      errorText: errorText,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Icon? buildPasswordIcon() {
    if (isPasswordValid == null) return null;
    return Icon(
      isPasswordValid! ? Icons.check_circle_outline : Icons.error_outline,
      color: isPasswordValid! ? Colors.green : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        resetValidation();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1B2E),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Column(
                children: [
                  Image.asset(
                    'assets/images/KalamKart_logo.png',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "KalamKart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: BlocConsumer<LoginViewModel, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ListView(
                        children: [
                          TextField(
                            controller: emailController,
                            onTap: resetValidation,
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                            decoration: buildInputDecoration(
                              hintText: 'Email',
                              icon: Icons.email_outlined,
                              errorText: emailError,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                            decoration: buildInputDecoration(
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              errorText: passwordError,
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (buildPasswordIcon() != null) buildPasswordIcon()!,
                                  IconButton(
                                    icon: Icon(
                                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                resetValidation();
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                          state is LoginLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: onLoginPressed,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 52),
                                    backgroundColor: const Color(0xFF0A1B2E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("or", style: TextStyle(fontSize: 14, fontFamily: 'Roboto')),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/images/google_logo.png', height: 22),
                            label: const Text(
                              "Continue with Google",
                              style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  resetValidation();
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
