import 'dart:io';

import 'package:awady/core/helpers/assets.dart';
import 'package:awady/core/helpers/extentions.dart';
import 'package:awady/core/helpers/local_auth_utils.dart';
import 'package:awady/core/routing/routes.dart';
import 'package:awady/core/theming/colors.dart';
import 'package:awady/core/theming/styles.dart';
import 'package:awady/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class LocalAuthView extends StatefulWidget {
  const LocalAuthView({super.key});

  @override
  State<LocalAuthView> createState() => _LocalAuthViewState();
}

class _LocalAuthViewState extends State<LocalAuthView> {
  late final LocalAuthUtils auth;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthUtils();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = await auth.canCheckBiometrics();
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = await auth.authenticate();
    if (authenticated) navigateOptions(authenticated);
  }

  void navigateOptions(bool authenticated) {
    context.pushReplacementNamed(Routes.homeView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Platform.isIOS ? 'Face ID' : "Finger Print",
              style: Styles.bold24.copyWith(color: ColorsManager.mainBlue),
            ),
            Gap(8.h),
            Text(
              Platform.isIOS
                  ? 'Add a Face ID to make your account more secure and easy to sign in.'
                  : 'Add a Finger Print to make your account more secure and easy to sign in.',
              style: Styles.regular14,
            ),
            const Spacer(),
            Gap(26.h),
            Center(
              child: CircleAvatar(
                radius: 120.w,
                backgroundColor: const Color(0xffF4F8FF),
                child: Platform.isIOS
                    ? SvgPicture.asset(Assets.imagesFaceScanner)
                    : Padding(
                        padding: EdgeInsets.all(80.h),
                        child: Image.asset(Assets.imagesFingerprint),
                      ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            AppTextButton(
              text: _canCheckBiometrics ? "Authenticate" : "Submit",
              textStyle: Styles.semiBold16,
              onPressed: () {
                _authenticate();
              },
            ),
          ],
        ),
      )),
    );
  }
}
