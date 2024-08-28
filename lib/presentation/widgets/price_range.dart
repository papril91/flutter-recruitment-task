import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_state.dart';

class PriceRange extends StatelessWidget {
  const PriceRange({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeStateLoaded) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: homeCubit.minPriceController,
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
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: homeCubit.maxPriceController,
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
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
