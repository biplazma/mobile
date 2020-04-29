import 'package:flutter/material.dart';
import 'package:biplazma/util/app_colors.dart';
import 'package:biplazma/util/app_textStyles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.appBarTextStyle),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(decoration: BoxDecoration(gradient: AppColors.linearGradient)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.0);
}
