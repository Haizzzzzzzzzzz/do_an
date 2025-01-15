import 'package:flutter/material.dart';

class buildDivider extends StatelessWidget {
  const buildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.grey,
      thickness: 0.5,
      indent: 10,
      endIndent: 10,
    );
  }
}
