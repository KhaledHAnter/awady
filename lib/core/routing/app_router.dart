import 'package:awady/core/routing/routes.dart';
import 'package:awady/features/home/ui/views/home_view.dart';
import 'package:awady/features/local_auth/ui/views/local_auth_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    // this arguments to be passed in any screen like this (arguments: arguments as ClassName)
    final arrguments = settings.arguments;

    switch (settings.name) {
      case Routes.localAuthView:
        return MaterialPageRoute(
          builder: (_) => const LocalAuthView(),
        );
      case Routes.homeView:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text("No route defined for ${settings.name}"),
                  ),
                ));
    }
  }
}
