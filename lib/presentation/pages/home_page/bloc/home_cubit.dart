import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_state.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.productsRepository, this.findProductId})
      : super(const HomeState.loading()) {
    minPriceController = TextEditingController();
    maxPriceController = TextEditingController();

    minPriceController.addListener(_onMinPriceChanged);
    maxPriceController.addListener(_onMaxPriceChanged);
  }

  final String? findProductId;
  final ProductsRepository productsRepository;
  late final TextEditingController minPriceController;
  late final TextEditingController maxPriceController;

  Future<void> initialize() async {
    await fetchData();
  }

  void _onMinPriceChanged() {
    final minPrice = double.tryParse(minPriceController.text);
    setMinPrice(minPrice: minPrice ?? double.negativeInfinity);
  }

  void _onMaxPriceChanged() {
    final maxPrice = double.tryParse(maxPriceController.text);
    setMaxPrice(maxPrice: maxPrice ?? double.infinity);
  }

  Future<void> toggleFilterDrawer() async {
    final state = this.state;

    if (state is HomeStateLoaded) {
      emit(
        state.copyWith(toggleFilterDrawer: !state.toggleFilterDrawer),
      );
    }

    await getTags();
  }

  void toggleFavoritesProductsFilter() {
    final state = this.state;

    if (state is HomeStateLoaded) {
      emit(
        state.copyWith(
          toggleFavoritesProductsFilter: !state.toggleFavoritesProductsFilter,
        ),
      );
    }
  }

  Future<void> setMinPrice({required double minPrice}) async {
    final state = this.state;

    if (state is HomeStateLoaded) {
      emit(
        state.copyWith(
          minPrice: minPrice,
        ),
      );
    }
  }

  Future<void> setMaxPrice({required double maxPrice}) async {
    final state = this.state;

    if (state is HomeStateLoaded) {
      emit(
        state.copyWith(
          maxPrice: maxPrice,
        ),
      );
    }
  }

  void addToFilterTags(Tag tag) {
    final state = this.state;
    if (state is HomeStateLoaded) {
      final List<Tag> listOfTags = List.from(state.listOfFilterTags ?? []);

      if (listOfTags.contains(tag)) {
        listOfTags.remove(tag);
      } else {
        listOfTags.add(tag);
      }
      emit(
        state.copyWith(
          listOfFilterTags: listOfTags,
        ),
      );
    }
  }

  Future<void> clearFilters() async {
    final state = this.state;
    if (state is HomeStateLoaded) {
      minPriceController.clear();
      maxPriceController.clear();

      emit(
        state.copyWith(
          listOfFilterTags: [],
          toggleFavoritesProductsFilter: false,
          minPrice: double.negativeInfinity,
          maxPrice: double.infinity,
        ),
      );
    }
    await fetchData();
  }

  Future<void> getTags() async {
    final state = this.state;
    List<Tag> allTagsList = [];

    if (state is HomeStateLoaded) {
      if (state.totalPages != null) {
        for (int i = 0; i < state.totalPages!; i++) {
          final tags = state.pages
              .map((page) => page.products)
              .expand((products) => products)
              .expand((product) => product.tags)
              .toSet()
              .toList();

          allTagsList.addAll(tags);
        }
      }

      final uniqueTags = allTagsList.toSet().toList();
      emit(state.copyWith(listOfTags: uniqueTags));
    }
  }

  Future<void> filterProducts() async {
    final state = this.state;
    List<Product> favoritesList = [];
    List<Product> priceList = [];
    List<Product> taggedList = [];
    List<Product> filteredProducts = [];

    if (state is HomeStateLoaded) {
      if (state.totalPages != null) {
        for (int i = 0; i < state.totalPages!; i++) {
          // by favorites
          if (state.toggleFavoritesProductsFilter) {
            final favorites = state.pages
                .map((page) => page.products)
                .expand((product) => product)
                .where((product) => product.isFavorite == true)
                .toList();

            favoritesList.addAll(favorites);
          }

          // by price
          if (state.minPrice != null || state.maxPrice != null) {
            final price = state.pages
                .map((page) => page.products)
                .expand((product) => product)
                .where((product) =>
                    product.offer.regularPrice.amount >= state.minPrice! &&
                    product.offer.regularPrice.amount <= state.maxPrice!)
                .toList();
            priceList.addAll(price);
          }

          // by tags
          if (state.listOfFilterTags != null &&
              state.listOfFilterTags!.isNotEmpty) {
            final tagged = state.pages
                .map((page) => page.products)
                .expand((product) => product)
                .where((product) => product.tags
                    .any((tag) => state.listOfFilterTags!.contains(tag)))
                .toList();

            taggedList = tagged;
          }
        }
      }

      filteredProducts = [...taggedList, ...favoritesList, ...priceList];
      emit(state.copyWith(
        products: filteredProducts,
        toggleFilterDrawer: false,
      ));
    }
  }

  Future<void> findProductById({required String productId}) async {
    final state = this.state;
    List<ProductsPage> pageProductsList = [];
    bool productFound = false;
    final totalPages = state is HomeStateLoaded ? state.totalPages : null;

    if (totalPages == null) {
      emit(
        const HomeState.error(
          errorMessage:
              'Oops, coś poszło nie tak. Produkt nie został znaleziony',
        ),
      );
      return;
    }

    for (int i = 0; i < totalPages; i++) {
      final pageProducts = await productsRepository
          .getProductsPage(GetProductsPage(pageNumber: i + 1));

      pageProductsList.add(pageProducts);

      if (pageProducts.products.any((product) => product.id == productId)) {
        productFound = true;
      }
    }

    if (productFound) {
      emit(HomeState.loaded(
        pages: pageProductsList,
        scrollToProductId: productId,
        totalPages: totalPages,
      ));
    } else {
      emit(
        const HomeState.error(
          errorMessage:
              'Oops, coś poszło nie tak. Produkt nie został znaleziony',
        ),
      );
    }
  }

  Future<void> getNextPage() async {
    try {
      final state = this.state;
      if (state is HomeStateLoaded) {
        final pages = List.from(state.pages);
        final totalPages = state.pages.lastOrNull?.totalPages;

        if (totalPages != null && state.currentPageNumber >= totalPages) return;
        final newPage = await productsRepository.getProductsPage(
          GetProductsPage(
            pageNumber: state.currentPageNumber + 1,
          ),
        );
        pages.add(newPage);

        final List<ProductsPage> newPagesToList = List.from(state.pages);
        newPagesToList.add(newPage);

        final products = newPagesToList
            .map((page) => page.products)
            .expand((product) => product)
            .toList();

        emit(state.copyWith(
          pages: newPagesToList,
          products: products,
          totalPages: totalPages,
          currentPageNumber: newPagesToList.length,
        ));
      }
    } catch (e) {
      emit(HomeStateError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchData() async {
    try {
      final initPage = await productsRepository
          .getProductsPage(GetProductsPage(pageNumber: 1));

      final products = initPage.products;

      emit(HomeState.loaded(
        pages: [initPage],
        products: products,
        currentPageNumber: 1,
        totalPages: initPage.totalPages,
      ));
    } catch (e) {
      emit(HomeState.error(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    minPriceController.dispose();
    maxPriceController.dispose();
    return super.close();
  }
}
