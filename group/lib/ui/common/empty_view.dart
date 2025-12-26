import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String text;
  const EmptyView(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
