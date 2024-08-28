import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/widgets/price_range.dart';

class BottomDrawer extends StatelessWidget {
  const BottomDrawer({
    super.key,
    required this.isDrawerOpen,
    required this.isFavorites,
  });

  final bool isDrawerOpen;
  final bool isFavorites;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        if (isDrawerOpen)
          Container(
            color: const Color.fromARGB(49, 69, 69, 69),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCirc,
          left: 0,
          right: 0,
          bottom: !isDrawerOpen ? fullHeight : 0,
          height: fullHeight / 2,
          child: Container(
            padding: const EdgeInsets.only(bottom: 40),
            color: const Color.fromARGB(255, 248, 239, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          context.read<HomeCubit>().toggleFilterDrawer(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const Row(
                        children: [Text('Tagi:')],
                      ),
                      Row(
                        children: [
                          const Text('Ulubione:'),
                          Checkbox(
                            value: isFavorites,
                            onChanged: (value) => context
                                .read<HomeCubit>()
                                .toggleFavoritesProductsFilter(),
                          ),
                        ],
                      ),
                      const PriceRange(),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          print('Button kliknięty!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Filtruj',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
