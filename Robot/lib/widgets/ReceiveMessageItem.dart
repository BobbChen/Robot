import 'dart:ui';

import 'package:robot/models/Message.dart';
import 'package:robot/widgets/Triangle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Triangle.dart';

import 'package:markdown_widget/markdown_widget.dart';
class Receivemessageitem extends StatelessWidget {
  const Receivemessageitem(this.message, this.bgColor, {super.key});
  final Message message;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
                image: AssetImage('images/avatar.png'),
              fit: BoxFit.fill
            )
          ),
        ),
        const SizedBox(width: 20),
        // 三角
        CustomPaint(
          painter: Triangle(bgColor),
        ),
        Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(right: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: MarkdownGenerator(richTextBuilder: (span){
                  if (span is TextSpan) {
                    return SelectableText.rich(span as TextSpan);
                  }
                  return Text.rich(span);
                }).buildWidgets(message.content),
              ),
            )
        )

      ],
    );
  }
}
