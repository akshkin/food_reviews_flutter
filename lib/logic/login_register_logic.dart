import 'package:flutter/material.dart';
import 'package:food_reviews/helper/validators.dart';
import 'package:food_reviews/models/user_model.dart';
import 'package:food_reviews/services/authentication_service.dart';
import 'package:food_reviews/services/database_service.dart';

class LoginRegisterInfo {
  bool buttonLoginRegisterEnabled;
  bool showLoginRegisterError;
  String loginRegisterErrorMessage;

  LoginRegisterInfo({
    required this.buttonLoginRegisterEnabled,
    required this.showLoginRegisterError,
    required this.loginRegisterErrorMessage,
  });
}

class LoginRegisterLogicClass extends ChangeNotifier {
  bool _isEmailOk = false;
  bool _isPasswordOk = false;
  bool _isConfirmPasswordOk = false;

  final LoginRegisterInfo _loginRegisterInfo = LoginRegisterInfo(
    buttonLoginRegisterEnabled: false,
    showLoginRegisterError: false,
    loginRegisterErrorMessage: "",
  );

  LoginRegisterInfo get loginRegisterInfo {
    return _loginRegisterInfo;
  }

  // user forgot password page
  void checkLoginEmail({required String email}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled = _isEmailOk ? true : false;
    notifyListeners();
  }

  void checkLoginEmailAndPassword(
      {required String email, required String password}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _isPasswordOk = Validators.password(password: password) ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled =
        _isEmailOk && _isPasswordOk ? true : false;
    notifyListeners();
  }

  void checkRegisterEmailAndPasswordAndConfirm(
      {required String email,
      required String password,
      required String confirmPassword}) {
    _loginRegisterInfo.showLoginRegisterError = false;
    _isEmailOk = Validators.email(email: email) ? true : false;
    _isPasswordOk = Validators.password(password: password) ? true : false;
    _isConfirmPasswordOk = password == confirmPassword ? true : false;
    _loginRegisterInfo.buttonLoginRegisterEnabled =
        _isEmailOk && _isPasswordOk && _isConfirmPasswordOk ? true : false;
    notifyListeners();
  }

  void showLoginErrorMessage({required String errorMessage}) {
    _loginRegisterInfo.showLoginRegisterError = true;
    _loginRegisterInfo.loginRegisterErrorMessage = errorMessage;
    notifyListeners();
  }

  void login({required String email, required String password}) {
    loginRegisterInfo.buttonLoginRegisterEnabled
        ? AuthenticationService.signInWithEmailAndPassword(
                email: email, password: password)
            .then((uid) => uid)
            .onError((error, stackTrace) {
            showLoginErrorMessage(errorMessage: "$error");
          })
        : null;
  }

  void register({required String email, required String password}) {
    AuthenticationService.createUserWithEmailAndPassword(
            email: email, password: password)
        .then((uid) {
      UserModel userModel = UserModel.initializeNewUserWithDefaultValues(
          uid: uid!, email: email, providerId: "password");

      DatabaseService.addUser(userModel)
          .then((value) => debugPrint("success"))
          .onError((error, stackTrace) =>
              showLoginErrorMessage(errorMessage: "$error"));
    }).onError((error, stackTrace) {
      showLoginErrorMessage(errorMessage: "$error");
    });
  }
}
