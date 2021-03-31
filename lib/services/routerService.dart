import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ramo/pages/signinpage.dart';
import 'package:ramo/pages/signuppage.dart';
import 'package:ramo/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => MyApp());
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
