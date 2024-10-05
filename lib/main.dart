import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_reviews/firebase_options.dart';
import 'package:food_reviews/helper/routes.dart';
import 'package:food_reviews/helper/themes.dart';
import 'package:food_reviews/pages/authentication/authentication_login.dart';
import 'package:food_reviews/pages/authentication/authentication_signup.dart';
import 'package:food_reviews/pages/authentication/forgot_password.dart';
import 'package:food_reviews/pages/home.dart';
import 'package:food_reviews/services/authentication_service.dart';
import 'package:food_reviews/state/authentication_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: null,
        stream: AuthenticationService.userAuthStateChanges,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              if (snapshot.hasData) {
                return AuthenticationState(
                  uid: snapshot.data.uid,
                  child: const BuildMaterialApp(initialRoute: MyHomePage.route),
                );
              } else {
                return const BuildMaterialApp(initialRoute: UserLogin.route);
              }
            default:
              return const BuildMaterialApp(
                initialRoute: UserLogin.route,
              );
          }
        });
  }
}

class BuildMaterialApp extends StatelessWidget {
  const BuildMaterialApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      key: Key(DateTime.now().toString()),
      title: 'Food reviews',
      theme: Themes.lightTheme(),
      darkTheme: Themes.darkTheme(),
      themeMode: ThemeMode.system,
      home: const ForgotPassword(),
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
