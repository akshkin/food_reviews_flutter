import 'package:firebase_auth/firebase_auth.dart';

class Validators {
  static bool email({required String email}) {
    final emailRegex = RegExp(
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""");
    return emailRegex.hasMatch(email) ? true : false;
  }

  static bool password({required String password}) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#%^&*])(?=.*[0-9])(?=.*[a-z]).{6,}$');
    return passwordRegex.hasMatch(password) ? true : false;
  }
}
