import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/config/markdown_generator.dart';

import '../models/Message.dart';
import 'Triangle.dart';

class Sendmessageitem extends StatelessWidget {
  const Sendmessageitem({super.key, required this.message, required this.bgColor});
  final Message message;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
            child:Container(
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: MarkdownGenerator(richTextBuilder: (span) => SelectableText.rich(span as TextSpan)).buildWidgets(message.content),
              ),
            )
        ),
        // 绘制三角
        CustomPaint(
          painter: Triangle(bgColor),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
