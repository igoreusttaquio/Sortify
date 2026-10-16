import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Standard page scroll container: padding, max content width and centered.
class PageBody extends StatelessWidget {
  const PageBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppLayout.pagePadding),
    this.maxWidth = AppLayout.contentMaxWidth,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
