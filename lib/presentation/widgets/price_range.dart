import 'package:flutter/material.dart';

class PriceRange extends StatefulWidget {
  const PriceRange({
    super.key,
  });

  @override
  State<PriceRange> createState() => _PriceRangeState();
}

class _PriceRangeState extends State<PriceRange> {
  final TextEditingController _minPricecontroller = TextEditingController();
  final TextEditingController _maxPricecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _minPricecontroller.addListener(() {
      print(_minPricecontroller.text);
    });

    _maxPricecontroller.addListener(() {
      print(_maxPricecontroller.text);
    });
  }

  @override
  void dispose() {
    _minPricecontroller.dispose();
    _maxPricecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minPricecontroller,
            decoration: const InputDecoration(
              labelText: "cena min",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintTextDirection: TextDirection.ltr,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: _maxPricecontroller,
            decoration: const InputDecoration(
              labelText: "cena max",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintTextDirection: TextDirection.ltr,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
