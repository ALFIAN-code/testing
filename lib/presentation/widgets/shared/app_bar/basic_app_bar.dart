import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../icon/custom_icon.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;
  final String? subtitle;
  final String icon;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const BasicAppBar({
    super.key,
    this.showBackButton = false,
    required this.title,
    required this.icon,
    this.subtitle,
    this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) => AppBar(
    leading: showBackButton ? _backButton(context) : null,
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    automaticallyImplyLeading: false,
    title: Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIcon(icon, color: Colors.white, width: 20, height: 20),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              subtitle != null
                  ? Text(
                    subtitle ?? '-',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color.fromRGBO(120, 130, 157, 1),
                    ),
                    maxLines: 2,

                    textAlign: TextAlign.start,
                  )
                  : Container(),
            ],
          ),
        ),
      ],
    ),
    actions: actions,
  );

  Widget _backButton(BuildContext context) => GestureDetector(
    onTap: onBack ?? () => context.router.back(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        width: 44,
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E4E4)),
        ),
        child: const Center(
          child: CustomIcon(
            KeenIconConstants.blackRightOutline,
            color: Colors.black87,
            width: 20,
            height: 20,
          ),
        ),
      ),
    ),
  );

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
