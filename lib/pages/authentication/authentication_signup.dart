import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/validators.dart';
import 'package:food_reviews/logic/login_register_logic.dart';
import 'package:food_reviews/pages/authentication/authentication_login.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  static const String route = "/signup";

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final LoginRegisterLogicClass _loginRegisterLogic = LoginRegisterLogicClass();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _loginRegisterLogic.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
                ],
                stops: const [0.0, 0.4],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: ResponsiveSizes.mobile.value,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.person,
                      color: Colors.green[300],
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: const Icon(Icons.email),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) {
                        return Validators.email(email: email!)
                            ? null
                            : "Enter a valid email";
                      },
                      onChanged: (email) {
                        _loginRegisterLogic
                            .checkRegisterEmailAndPasswordAndConfirm(
                          email: _emailController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: const Icon(Icons.lock),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        return Validators.password(password: password!)
                            ? null
                            : "6+ characters, 1 number, 1 Uppercase, 1 symbol";
                      },
                      onChanged: (value) {
                        _loginRegisterLogic
                            .checkRegisterEmailAndPasswordAndConfirm(
                          email: _emailController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: "Confirm Password",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        return Validators.password(password: password!)
                            ? null
                            : "6+ characters, 1 number, 1 Uppercase, 1 symbol";
                      },
                      onChanged: (value) {
                        _loginRegisterLogic
                            .checkRegisterEmailAndPasswordAndConfirm(
                          email: _emailController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _loginRegisterLogic,
                      builder: (BuildContext context, Widget? widget) {
                        return ElevatedButton(
                          onPressed: _loginRegisterLogic
                                  .loginRegisterInfo.buttonLoginRegisterEnabled
                              ? () => _loginRegisterLogic.register(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              : null,
                          style: ElevatedButton.styleFrom(elevation: 8),
                          child: const Text("Register"),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _loginRegisterLogic,
                      builder: (BuildContext context, Widget? widget) {
                        return Visibility(
                          visible: _loginRegisterLogic
                              .loginRegisterInfo.showLoginRegisterError,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      endIndent: 16,
                                    ),
                                  ),
                                  Text(
                                    _loginRegisterLogic.loginRegisterInfo
                                        .loginRegisterErrorMessage
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      indent: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(UserLogin.route),
                          child: const Text("Already registered? Login "),
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
