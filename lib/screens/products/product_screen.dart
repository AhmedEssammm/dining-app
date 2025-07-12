import 'package:dining_app/cubits/favorites/favorites_cubit.dart';
import 'package:dining_app/cubits/product/product_cubit.dart';
import 'package:dining_app/cubits/product/product_state.dart';
import 'package:dining_app/models/product.dart';
import 'package:dining_app/models/restaurant.dart';
import 'package:dining_app/screens/checkout/checkout_screen.dart';
import 'package:dining_app/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  final Restaurant restaurant;

  const ProductScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..loadProducts(restaurant.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            restaurant.name,
          ),
          actions: [
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
            RestaurantHeader(restaurant: restaurant),
            const Divider(
              height: 1,
              color: Color(0xFF3BD4AE),
            ),
            Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    onChanged: (query) {
                      context.read<ProductCubit>().searchProducts(query);
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    final products = state.products;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF083B55),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            restaurant.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3BD4AE),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            restaurant.description,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text(restaurant.rating.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF083B55),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: SizedBox(
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: BlocBuilder<FavoritesCubit, List<Product>>(
          builder: (context, favorites) {
            final isFav = context.read<FavoritesCubit>().isFavorite(product);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? const Color(0xFF3BD4AE) : Colors.grey,
              ),
              onPressed: () {
                context.read<FavoritesCubit>().toggleFavorite(product);
              },
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            ),
          );
        },
      ),
    );
  }
}
