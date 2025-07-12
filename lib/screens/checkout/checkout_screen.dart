import 'package:dining_app/cubits/basket/basket_cubit.dart';
import 'package:dining_app/models/basket_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<BasketCubit, List<BasketItem>>(
        builder: (context, basket) {
          if (basket.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Color(0xFF3BD4AE),
                  ),
                  Text(
                    'Your basket is empty.',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF3BD4AE),
                    ),
                  ),
                ],
              ),
            );
          }

          final total = context.read<BasketCubit>().totalPrice;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: basket.length,
                  itemBuilder: (context, index) {
                    final item = basket[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Color(0xFF083B55),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text(
                          '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity} = \$${item.totalPrice.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.quantity > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  context
                                      .read<BasketCubit>()
                                      .removeOne(item.product);
                                },
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<BasketCubit>()
                                    .removeFromBasket(item.product);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xFF3BD4AE),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully!'),
                            ),
                          );
                          context.read<BasketCubit>().emit([]);
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
