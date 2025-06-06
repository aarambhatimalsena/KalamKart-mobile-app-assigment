import 'package:flutter/material.dart';

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
      } else if (password != '123456') {
        passwordError = 'Invalid password';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Login successful"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: const Duration(milliseconds: 800),
        ),
      );

      Navigator.pushReplacementNamed(context, '/dashboard');
      resetValidation();
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

  OutlineInputBorder buildPasswordBorder() {
    if (isPasswordValid == null) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isPasswordValid! ? Colors.green : Colors.red,
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
                  child: ListView(
                    children: [
                      TextField(
                        controller: emailController,
                        onTap: resetValidation,
                        style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: emailError,
                          // 💡 fillColor, border handled by theme
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
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
                          border: buildPasswordBorder(),
                          errorText: passwordError,
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
                      ElevatedButton(
                        onPressed: onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
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
