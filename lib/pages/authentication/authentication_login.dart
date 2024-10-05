import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/validators.dart';
import 'package:food_reviews/logic/login_register_logic.dart';
import 'package:food_reviews/pages/authentication/authentication_signup.dart';
import 'package:food_reviews/pages/authentication/forgot_password.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  static const String route = "/login";

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final LoginRegisterLogicClass _loginRregisterLogic =
      LoginRegisterLogicClass();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  Theme.of(context).secondaryHeaderColor,
                ],
                stops: const [0.0, 0.4],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: ResponsiveSizes.mobile.value,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.green[300],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        icon: const Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) => Validators.email(email: email!)
                          ? null
                          : "Enter a valid email",
                      onChanged: (email) {
                        _loginRregisterLogic.checkLoginEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        icon: const Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) => Validators.password(
                              password: password!)
                          ? null
                          : "6+ characters, 1 number, 1 uppercase, 1 symbol",
                      onChanged: (password) {
                        _loginRregisterLogic.checkLoginEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                      onFieldSubmitted: (password) =>
                          _loginRregisterLogic.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _loginRregisterLogic,
                      builder: (BuildContext context, Widget? widget) {
                        return ElevatedButton(
                          onPressed: _loginRregisterLogic
                                  .loginRegisterInfo.buttonLoginRegisterEnabled
                              ? () => _loginRregisterLogic.login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  )
                              : null,
                          style: ElevatedButton.styleFrom(elevation: 8),
                          child: const Text("Login"),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _loginRregisterLogic,
                      builder: (BuildContext context, Widget? widget) {
                        return Visibility(
                          visible: _loginRregisterLogic
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
                                    _loginRregisterLogic.loginRegisterInfo
                                        .loginRegisterErrorMessage
                                        .toString(),
                                  ),
                                  const Expanded(
                                    child: Divider(indent: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(ForgotPassword.route),
                      child: Text(
                        "Forgot Password? ",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 16,
                          ),
                        ),
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(UserSignup.route),
                          child: const Text("Create account"),
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 16,
                          ),
                        )
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
