import 'package:flutter/material.dart';

class GreenSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled,
    bool isDiscrete,
  }) {
    final double thumbWidth =
        sliderTheme.thumbShape.getPreferredSize(true, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + thumbWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - thumbWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    Offset thumbCenter,
    bool isDiscrete,
    bool isEnabled,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor
      ..style = PaintingStyle.fill;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor
      ..style = PaintingStyle.fill;

    final pathSegment = Path()
      ..moveTo(trackRect.left, trackRect.top - 5)
      ..lineTo(trackRect.right, trackRect.top - 5)
      ..lineTo(trackRect.right, trackRect.bottom + 5)
      ..lineTo(trackRect.left, trackRect.bottom + 5)
      ..lineTo(trackRect.left, trackRect.top - 5);
    final activePathSegment = Path()
      ..moveTo(trackRect.left, trackRect.top - 5)
      ..lineTo(thumbCenter.dx, trackRect.top - 5)
      ..lineTo(thumbCenter.dx, trackRect.bottom + 5)
      ..lineTo(trackRect.left, trackRect.bottom + 5)
      ..lineTo(trackRect.left, trackRect.top - 5);

    context.canvas.drawPath(pathSegment, inactivePaint);
    context.canvas.drawPath(activePathSegment, activePaint);
  }
}
