import 'package:dining_app/mock/mock_restaurants.dart';
import 'package:dining_app/models/restaurant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final List<Restaurant> _allRestaurants = mockRestaurants;

  RestaurantCubit() : super(RestaurantInitial());

  void loadRestaurants() {
    emit(RestaurantLoaded(_allRestaurants));
  }

  void searchRestaurants(String query) {
    final filtered = _allRestaurants.where((restaurant) {
      final nameMatch =
          restaurant.name.toLowerCase().contains(query.toLowerCase());
      final categoryMatch =
          restaurant.category.toLowerCase().contains(query.toLowerCase());
      return nameMatch || categoryMatch;
    }).toList();

    emit(RestaurantLoaded(filtered));
  }
}
