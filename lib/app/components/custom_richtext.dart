import 'package:flutter/material.dart';

class HighlightRichText extends StatelessWidget {
  const HighlightRichText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> textSpans = [];
    final RegExp regex = RegExp(r"\#(\w+)");
    final Iterable<Match> matches = regex.allMatches(text);
    int start = 0;
    for (final Match match in matches) {
      textSpans.add(TextSpan(text: text.substring(start, match.start)));
      textSpans.add(WidgetSpan(
          child: GestureDetector(
              onTap: () =>  print("You tapped #${match.group(1)}"),
              child: Text('#${match.group(1)}',
                  style: const TextStyle(fontWeight: FontWeight.w600)))));
      start = match.end;
    }
    textSpans.add(TextSpan(text: text.substring(start, text.length)));
    return Text.rich(TextSpan(children: textSpans));
  }
}
