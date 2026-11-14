import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class CircularProgressPainter extends CustomPainter {
  final double currentStep;
  final double maxStep;
  final double widthLine;
  final double heightLine;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Gradient? gradientColor;

  CircularProgressPainter({
    required this.maxStep,
    required this.widthLine,
    required this.heightLine,
    required this.currentStep,
    required this.selectedColor,
    required this.unselectedColor,
    required this.gradientColor,
  });
  double get maxDefinedSize {
    return math.max(1, math.max(0, 0));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Paint paint = Paint()..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(
      center: Offset(w / 2, h / 2),
      height: h - maxDefinedSize,
      width: w - maxDefinedSize,
    );

    if (gradientColor != null) {
      paint.shader = gradientColor!.createShader(rect);
    }
    _drawStepArc(canvas, paint, rect, size);
  }

  /// Draw a series of arcs, each composing the full steps of the indicator
  void _drawStepArc(Canvas canvas, Paint paint, Rect rect, Size size) {
    var centerX = rect.center.dx;
    var centerY = rect.center.dy;
    var radius = math.min(centerX, centerY);

    var draw = (360 * currentStep) / maxStep;
    var stepLine = 360 / maxStep;

    for (double i = 0; i < 360; i += stepLine) {
      var outerCircleRadius = (radius - (i < draw ? 0 : heightLine / 2));
      var innerCircleRadius = (radius - heightLine);

      var x1 = centerX + outerCircleRadius * math.cos(i * math.pi / 180);
      var y1 = centerX + outerCircleRadius * math.sin(i * math.pi / 180);
      //
      var x2 = centerX + innerCircleRadius * math.cos(i * math.pi / 180);
      var y2 = centerX + innerCircleRadius * math.sin(i * math.pi / 180);
      var dashBrush = paint
        ..color = i < draw
            ? selectedColor ?? Colors.red
            : unselectedColor ?? Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = widthLine;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
