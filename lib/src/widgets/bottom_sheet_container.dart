import 'package:flutter/material.dart';
import 'package:roqqu_binance/src/core/constants/app_colors.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';

class BottomSheetContainer extends StatelessWidget {
  final List<Widget> children;

  const BottomSheetContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 28,
            bottom: 28,
            right: 32,
            left: 32,
          ),
          children: [
            ...children,
            const SizedBox(height: 10),
          ],
        ),
      );

  void show(BuildContext context) => showModalBottomSheet(
        backgroundColor: isLightMode(context)
            ? AppColors.angelWhitePrimary
            : AppColors.scaffoldDarkBackground,
        context: context,
        builder: (_) => this,
      );
}
