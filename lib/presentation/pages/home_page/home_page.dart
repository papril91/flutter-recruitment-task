import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_state.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';
import 'package:flutter_recruitment_task/presentation/widgets/bottom_drawer.dart';
import 'package:flutter_recruitment_task/presentation/widgets/product_card.dart';

const _mainPadding = EdgeInsets.only(
  top: 0,
  right: 16,
  bottom: 16,
  left: 16,
);

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.scrollToProductId});

  final int? scrollToProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText('Products'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.map(
              loading: (state) =>
                  const Center(child: CircularProgressIndicator()),
              loaded: (state) => _LoadedWidget(state: state),
              error: (error) => BigText('Error: ${error.errorMessage}'));
        },
      ),
    );
  }
}

class _LoadedWidget extends StatelessWidget {
  _LoadedWidget({
    required this.state,
  }) : _scrollController = ScrollController();

  final HomeStateLoaded state;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Stack(
      children: [
        Padding(
          padding: _mainPadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtry'),
                  if ((state.listOfFilterTags != null &&
                          state.listOfFilterTags!.isNotEmpty) ||
                      (state.minPrice != null || state.maxPrice != null))
                    ElevatedButton(
                      onPressed: () => cubit.clearFilters(),
                      child: const Text(
                        'Wyczyść',
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () => cubit.toggleFilterDrawer(),
                  ),
                ],
              ),
              Expanded(
                child: _ProductsSliverList(
                  state: state,
                  scrollController: _scrollController,
                ),
              ),
            ],
          ),
        ),
        BottomDrawer(
          isFavorites: state.toggleFavoritesProductsFilter,
          isDrawerOpen: state.toggleFilterDrawer,
          listOfTags: state.listOfTags ?? [],
          listOfFilterTags: state.listOfFilterTags ?? [],
        ),
      ],
    );
  }
}

class _ProductsSliverList extends StatelessWidget {
  const _ProductsSliverList(
      {required this.state, required this.scrollController});

  final HomeStateLoaded state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final products = state.products;

    return CustomScrollView(slivers: [
      SliverList.separated(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      const _GetNextPageButton()
    ]);
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
