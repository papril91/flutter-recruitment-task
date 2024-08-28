import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.loading() = HomeStateLoading;
  const factory HomeState.loaded({
    @Default([]) List<ProductsPage> pages,
    @Default([]) List<Product> products,
    @Default(false) bool toggleFilterDrawer,
    @Default(false) bool toggleFavoritesProductsFilter,
    double? minPrice,
    double? maxPrice,
    @Default(1) int currentPageNumber,
    List<Tag>? listOfTags,
    List<Tag>? listOfFilterTags,
    String? scrollToProductId,
    int? totalPages,
  }) = HomeStateLoaded;
  const factory HomeState.error({
    String? errorMessage,
  }) = HomeStateError;
}
