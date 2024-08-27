import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/widgets/tag_widget.dart';

class Tags extends StatelessWidget {
  const Tags({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: product.tags.map(TagWidget.new).toList(),
    );
  }
}
