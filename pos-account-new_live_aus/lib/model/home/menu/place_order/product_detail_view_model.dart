import 'pos_res/com/feature_product.dart';
import 'product_filter_option.dart';

class ProductDetailViewModel {
  List<ProductFilterOption>? filterCategoriesWithChildernFilterOptions;
  FeaturedProduct? productListViewModel;

  ProductDetailViewModel({
    this.filterCategoriesWithChildernFilterOptions,
    this.productListViewModel,
  });

  factory ProductDetailViewModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailViewModel(
        filterCategoriesWithChildernFilterOptions:
            json["filterCategoriesWithChildernFilterOptions"] == null
                ? []
                : List<ProductFilterOption>.from(
                    json["filterCategoriesWithChildernFilterOptions"]!
                        .map((x) => ProductFilterOption.fromJson(x))),
        productListViewModel: json["productListViewModel"] == null
            ? null
            : FeaturedProduct.fromJson(json["productListViewModel"]),
      );

  Map<String, dynamic> toJson() => {
        "filterCategoriesWithChildernFilterOptions":
            filterCategoriesWithChildernFilterOptions == null
                ? []
                : List<dynamic>.from(filterCategoriesWithChildernFilterOptions!
                    .map((x) => x.toJson())),
        "productListViewModel": productListViewModel?.toJson(),
      };
}
