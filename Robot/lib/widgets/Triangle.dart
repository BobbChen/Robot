import 'package:flutter/cupertino.dart';

class Triangle extends CustomPainter {
  final Color bgColor;

  Triangle(this.bgColor);
  // 绘制会话列表消息气泡的三角
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()..color = bgColor;
    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
