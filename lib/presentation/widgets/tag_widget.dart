import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';

class TagWidget extends StatelessWidget {
  const TagWidget(this.tag, {super.key});

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      return Color(int.parse('0x$hex'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: hexToColor(tag.color),
        label: Text(tag.label),
      ),
    );
  }
}
