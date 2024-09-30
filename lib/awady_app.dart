import 'package:awady/core/routing/app_router.dart';
import 'package:awady/core/routing/routes.dart';
import 'package:awady/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AwadyApp extends StatelessWidget {
  final AppRouter appRouter;
  const AwadyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        // home: LoginView(),
        debugShowCheckedModeBanner: false,
        title: "Doc Adavanced Flutter",
        theme: ThemeData(
          primaryColor: ColorsManager.mainBlue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: Routes.localAuthView,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
