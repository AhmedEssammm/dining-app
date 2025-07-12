import 'package:dining_app/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<List<Product>> {
  FavoritesCubit() : super([]);

  void toggleFavorite(Product product) {
    final currentFavorites = List<Product>.from(state);

    if (currentFavorites.any((p) => p.id == product.id)) {
      currentFavorites.removeWhere((p) => p.id == product.id);
      emit(currentFavorites);
    } else {
      currentFavorites.add(product);
      emit(currentFavorites);
    }
  }

  bool isFavorite(Product product) {
    return state.any((p) => p.id == product.id);
  }
}
