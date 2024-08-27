import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_state.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';
import 'package:flutter_recruitment_task/presentation/widgets/product_card.dart';

const _mainPadding = EdgeInsets.all(16.0);

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.scrollToProductId});

  final int? scrollToProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText('Products'),
      ),
      body: Padding(
        padding: _mainPadding,
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            // tutaj dodam metode do scrolla i filtry
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return state.map(
                  loading: (state) =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (state) => _LoadedWidget(state: state),
                  error: (error) => BigText('Error: ${error.errorMessage}'));
            },
          ),
        ),
      ),
    );
  }
}

class _LoadedWidget extends StatelessWidget {
  const _LoadedWidget({
    required this.state,
  });

  final HomeStateLoaded state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _ProductsSliverList(state: state),
        const _GetNextPageButton(),
      ],
    );
  }
}

class _ProductsSliverList extends StatelessWidget {
  const _ProductsSliverList({required this.state});

  final HomeStateLoaded state;

  @override
  Widget build(BuildContext context) {
    final products = state.pages
        .map((page) => page.products)
        .expand((product) => product)
        .toList();

    return SliverList.separated(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          key: ValueKey(products[index].id),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class _GetNextPageButton extends StatelessWidget {
  const _GetNextPageButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TextButton(
        onPressed: context.read<HomeCubit>().getNextPage,
        child: const BigText('Get next page'),
      ),
    );
  }
}
