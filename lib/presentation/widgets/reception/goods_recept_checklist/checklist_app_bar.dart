import 'package:flutter/material.dart';

import '../../../../core/constants/keen_icon_constants.dart';
import '../../shared/icon/custom_icon.dart';

class ChecklistAppBar extends StatelessWidget {
  const ChecklistAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    required this.icon,
    required this.showBackButton,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String icon;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          showBackButton
              ? Padding(
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
              )
              : Container(),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIcon(
                icon,
                color: Colors.white,
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
