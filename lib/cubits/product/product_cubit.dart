import 'package:dining_app/mock/mock_products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  void loadProducts(String restaurantId) async {
    emit(ProductLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final filtered = mockProducts
        .where((product) => product.restaurantId == restaurantId)
        .toList();
    emit(ProductLoaded(filtered));
  }
}
