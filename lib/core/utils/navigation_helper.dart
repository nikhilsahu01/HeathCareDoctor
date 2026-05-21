import 'package:flutter/material.dart';

/// Basic Navigation Helpers
void navPush({required BuildContext context, required Widget page}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

void navPushReplace({required BuildContext context, required Widget page}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

void navPushRemove({required BuildContext context, required Widget page}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => page),
        (_) => false,
  );
}

void navPop({required BuildContext context}) {
  Navigator.pop(context);
}

/// Internal helper for custom transitions
PageRouteBuilder _slideRoute({
  required Widget page,
  required Offset beginOffset,
  int duration = 300,
}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween(begin: beginOffset, end: Offset.zero)
          .chain(CurveTween(curve: Curves.ease));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

/// Slide from Left
void navSlideFromLeft(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.push(context, _slideRoute(page: page, beginOffset: Offset(-1.0, 0.0), duration: duration));
}

void navSlideFromLeftRemove(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.pushAndRemoveUntil(
    context,
    _slideRoute(page: page, beginOffset: Offset(-1.0, 0.0), duration: duration),
        (_) => false,
  );
}

/// Slide from Right
void navSlideFromRight(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.push(context, _slideRoute(page: page, beginOffset: Offset(1.0, 0.0), duration: duration));
}

void navSlideFromRightRemove(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.pushAndRemoveUntil(
    context,
    _slideRoute(page: page, beginOffset: Offset(1.0, 0.0), duration: duration),
        (_) => false,
  );
}

/// Slide from Top
void navSlideFromTop(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.push(context, _slideRoute(page: page, beginOffset: Offset(0.0, -1.0), duration: duration));
}

void navSlideFromTopRemove(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.pushAndRemoveUntil(
    context,
    _slideRoute(page: page, beginOffset: Offset(0.0, -1.0), duration: duration),
        (_) => false,
  );
}

/// Slide from Bottom
void navSlideFromBottom(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.push(context, _slideRoute(page: page, beginOffset: Offset(0.0, 1.0), duration: duration));
}

void navSlideFromBottomRemove(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.pushAndRemoveUntil(
    context,
    _slideRoute(page: page, beginOffset: Offset(0.0, 1.0), duration: duration),
        (_) => false,
  );
}

/// Fade Transition
void navFade(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

void navFadeRemove(BuildContext context, Widget page, {int duration = 300}) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
        (_) => false,
  );
}
