import 'package:dining_app/cubits/restaurant/restaurant_cubit.dart';
import 'package:dining_app/cubits/restaurant/restaurant_state.dart';
import 'package:dining_app/models/restaurant.dart';
import 'package:dining_app/screens/checkout/checkout_screen.dart';
import 'package:dining_app/screens/favorites/favorites_screen.dart';
import 'package:dining_app/screens/products/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantCubit()..loadRestaurants(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/images/logo.png', height: 30),
              const SizedBox(width: 10),
              const Text('Restaurants'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search restaurants...',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onChanged: (query) {
                      context.read<RestaurantCubit>().searchRestaurants(query);
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<RestaurantCubit, RestaurantState>(
                builder: (context, state) {
                  if (state is RestaurantLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RestaurantLoaded) {
                    if (state.restaurants.isEmpty) {
                      return const Center(child: Text('No restaurants found.'));
                    }
                    return ListView.builder(
                      itemCount: state.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = state.restaurants[index];
                        return RestaurantCard(restaurant: restaurant);
                      },
                    );
                  } else if (state is RestaurantError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF083B55),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3BD4AE),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.description,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toString(),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductScreen(restaurant: restaurant),
            ),
          );
        },
      ),
    );
  }
}
