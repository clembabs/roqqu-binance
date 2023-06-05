import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roqqu_binance/src/core/constants/app_theme.dart';
import 'package:roqqu_binance/src/core/constants/images.dart';
import 'package:roqqu_binance/src/core/constants/svgs.dart';
import 'package:roqqu_binance/src/core/utilities/platform_svg.dart';
import 'package:roqqu_binance/src/features/home/widgets/drawer.dart';

final drawerOpenProvider = StateProvider<bool>((ref) => false);

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 22.4.w, 16.h),
      child: Row(
        children: [
          PlatformSvg.asset(isLightMode(context)
              ? SvgIcons.lightLogomark
              : SvgIcons.logomark),
          const Spacer(),
          Image.asset(AppImages.profile),
          SizedBox(width: 18.w),
          PlatformSvg.asset(
              isLightMode(context) ? SvgIcons.lightglobe : SvgIcons.globe),
          SizedBox(width: 20.8.w),
          GestureDetector(
            onTap: () => showCustomPopupMenu(context),
            child: PlatformSvg.asset(
                isLightMode(context) ? SvgIcons.lightmenu : SvgIcons.menu),
          ),
        ],
      ),
    );
  }
}
