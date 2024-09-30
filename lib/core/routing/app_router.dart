import 'package:Awady/core/routing/routes.dart';
import 'package:Awady/features/home/data/phone_model.dart';
import 'package:Awady/features/home/ui/views/home_view.dart';
import 'package:Awady/features/local_auth/ui/views/local_auth_view.dart';
import 'package:Awady/features/phone_details/ui/views/item_details_view.dart';
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
      case Routes.itemDetailView:
        arrguments as PhoneModel;
        return MaterialPageRoute(
          builder: (_) => ItemDetailsView(
            phone: arrguments,
          ),
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
