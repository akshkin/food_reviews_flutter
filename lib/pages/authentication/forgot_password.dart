import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_reviews/helper/constants.dart';
import 'package:food_reviews/helper/validators.dart';
import 'package:food_reviews/logic/login_register_logic.dart';
import 'package:food_reviews/pages/authentication/authentication_login.dart';
import 'package:food_reviews/services/authentication_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const String route = "/forgot_password";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final LoginRegisterLogicClass _loginRegisterLogic = LoginRegisterLogicClass();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                    const SizedBox(height: 50),
                    const Icon(
                      Icons.question_mark_outlined,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Email",
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
                      validator: (email) => Validators.email(email: email!)
                          ? null
                          : "Enter a valid email address",
                      onChanged: (email) {
                        _loginRegisterLogic.checkLoginEmail(
                            email: _emailController.text);
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _loginRegisterLogic,
                      builder: (BuildContext context, Widget? widget) {
                        return ElevatedButton(
                          onPressed: _loginRegisterLogic
                                  .loginRegisterInfo.buttonLoginRegisterEnabled
                              ? () {
                                  AuthenticationService.sendPasswordReset(
                                          _emailController.text)
                                      .then((emailSent) {
                                    if (emailSent) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              UserLogin.route);
                                    }
                                  });
                                }
                              : null,
                          child: const Text("Reset Password"),
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
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
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
