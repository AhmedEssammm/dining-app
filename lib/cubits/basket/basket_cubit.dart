import 'package:dining_app/models/basket_item.dart';
import 'package:dining_app/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketCubit extends Cubit<List<BasketItem>> {
  BasketCubit() : super([]);

  void addToBasket(Product product, [int count = 1]) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      emit([...state, BasketItem(product: product, quantity: count)]);
    } else {
      final updated = [...state];
      final currentItem = updated[index];
      updated[index] = BasketItem(
        product: currentItem.product,
        quantity: currentItem.quantity + count,
      );
      emit(updated);
    }
  }

  void removeOne(Product product) {
    final updated = state
        .map((item) {
          if (item.product.id == product.id && item.quantity > 1) {
            return BasketItem(
                product: item.product, quantity: item.quantity - 1);
          }
          return item;
        })
        .where((item) => item.quantity > 0)
        .toList();
    emit(updated);
  }

  void removeFromBasket(Product product) {
    emit(state.where((item) => item.product.id != product.id).toList());
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
}
