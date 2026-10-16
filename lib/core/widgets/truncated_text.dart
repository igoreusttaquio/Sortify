import 'package:flutter/material.dart';

/// A [Text] that ellipsizes when it does not fit and, in that case, shows a
/// tooltip with the full content.
class TruncatedText extends StatelessWidget {
  const TruncatedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.textAlign,
    this.softWrap = false,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextAlign? textAlign;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;

    final child = Text(
      text,
      style: style,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) return child;

        final painter = TextPainter(
          text: TextSpan(text: text, style: effectiveStyle),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textAlign: textAlign ?? TextAlign.start,
        )..layout(maxWidth: constraints.maxWidth);

        if (!painter.didExceedMaxLines) return child;

        return Tooltip(
          message: text,
          waitDuration: const Duration(milliseconds: 400),
          child: child,
        );
      },
    );
  }
}
