import 'package:flutter/material.dart';
import 'package:valeeze/theme/theme.dart';

class HeaderCurvedContainer extends CustomPainter {
  final Color color;
  final double dy;
  final double y1;
  HeaderCurvedContainer(
      {required this.color, required this.dy, required this.y1});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path()
      ..relativeLineTo(0, dy)
      ..quadraticBezierTo(size.width / 2, y1, size.width, dy)
      ..relativeLineTo(0, -dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//actual one

// import 'package:flutter/material.dart';
// import 'package:valeeze/theme/theme.dart';
//
// class HeaderCurvedContainer extends CustomPainter {
//   final Color color;
//   HeaderCurvedContainer({required this.color});
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//     Path path = Path()
//       ..relativeLineTo(0, 150)
//       ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
//       ..relativeLineTo(0, -150)
//       ..close();
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
