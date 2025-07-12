import 'package:dining_app/mock/mock_products.dart';
import 'package:dining_app/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final List<Product> _allProducts = [];

  ProductCubit() : super(ProductInitial());

  void loadProducts(String restaurantId) async {
    emit(ProductLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final filtered = mockProducts
        .where((product) => product.restaurantId == restaurantId)
        .toList();
    _allProducts.clear();
    _allProducts.addAll(filtered);
    emit(ProductLoaded(filtered));
  }

  void searchProducts(String query) {
    final current = _allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(ProductLoaded(current));
  }
}
