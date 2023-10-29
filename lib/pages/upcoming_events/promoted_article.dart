import 'package:flutter/material.dart';

import '/theme.dart';

class PromotedArticle extends StatelessWidget {
  const PromotedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: OnlineTheme.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
