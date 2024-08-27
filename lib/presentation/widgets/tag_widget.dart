import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';

class TagWidget extends StatelessWidget {
  const TagWidget(this.tag, {super.key});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    const possibleColors = Colors.primaries;
    final tagColor = possibleColors[tag.label.hashCode % possibleColors.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: tagColor,
        label: Text(tag.label),
      ),
    );
  }
}
