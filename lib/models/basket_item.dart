import 'product.dart';

class BasketItem {
  final Product product;
  int quantity;

  BasketItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
