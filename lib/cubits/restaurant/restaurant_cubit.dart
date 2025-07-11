import 'package:dining_app/mock/mock_restaurants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantInitial());

  void loadRestaurants() async {
    emit(RestaurantLoading());
    await Future.delayed(const Duration(seconds: 1)); // simulate loading
    emit(RestaurantLoaded(mockRestaurants));
  }
}
