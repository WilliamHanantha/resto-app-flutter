// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:resto_app/core/constants/colors.dart';

class ScrollBarView extends StatelessWidget {
  const ScrollBarView({
    Key? key,
    required this.scrollController,
    required this.child,
  }) : super(key: key);
  final ScrollController scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: AppColors.primary.withOpacity(1),
      trackColor: AppColors.blueLight,
      controller: scrollController,
      radius: const Radius.circular(8),
      thickness: 4,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: child,
      ),
    );
  }
}
