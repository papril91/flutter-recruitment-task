import 'package:bloc/bloc.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/bloc/home_state.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.productsRepository, this.findProductId})
      : super(const HomeState.loading());

  final String? findProductId;
  final ProductsRepository productsRepository;
  final List<ProductsPage> _pages = [];
  var _param = GetProductsPage(pageNumber: 1);

  Future<void> initialize() async {
    await getNextPage();
    if (findProductId != null) {
      print('Starting to search and scroll to product id: $findProductId');
      findProductById(productId: findProductId!);
    } else {
      print('No product to find and scroll');
    }
  }

  Future<void> findProductById({required String productId}) async {
    List<ProductsPage> pageProductsList = [];
    bool productFound = false;
    final totalPages = _pages.lastOrNull?.totalPages;

    if (totalPages == null) {
      emit(const HomeState.error(
          errorMessage:
              'Oops, coś poszło nie tak. Produkt nie został znaleziony'));
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
      ));
    } else {
      emit(const HomeState.error(
          errorMessage:
              'Oops, coś poszło nie tak. Produkt nie został znaleziony'));
    }
  }

  Future<void> getNextPage() async {
    try {
      final totalPages = _pages.lastOrNull?.totalPages;
      if (totalPages != null && _param.pageNumber > totalPages) return;
      final newPage = await productsRepository.getProductsPage(_param);
      _param = _param.increasePageNumber();
      _pages.add(newPage);
      emit(HomeState.loaded(pages: _pages));
    } catch (e) {
      emit(HomeState.error(errorMessage: e.toString()));
    }
  }
}
