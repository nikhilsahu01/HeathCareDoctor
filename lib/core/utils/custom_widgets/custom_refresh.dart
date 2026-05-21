import 'package:flutter/material.dart';
import '../theams/color_resource.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorResource.white,
      color: ColorResource.primaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}