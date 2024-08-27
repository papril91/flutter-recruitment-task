import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState.loading() = HomeStateLoading;
  const factory HomeState.loaded({
    @Default([]) List<ProductsPage> pages,
    String? scrollToProductId,
  }) = HomeStateLoaded;
  const factory HomeState.error({
    String? errorMessage,
  }) = HomeStateError;
}
