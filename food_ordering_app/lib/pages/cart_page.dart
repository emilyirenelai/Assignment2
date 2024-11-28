import 'package:flutter/material.dart';
import '../database/shared_pref_helper.dart';
import '../models/food_item.dart';

class CartPage extends StatelessWidget {
  final String date;
  final Map<FoodItem, int> cart;
  final ValueChanged<Map<FoodItem, int>> onCartUpdate;

  const CartPage(
      {super.key,
      required this.cart,
      required this.onCartUpdate,
      required this.date});

  void removeFromCart(FoodItem item, BuildContext context) {
    final updatedCart = Map<FoodItem, int>.from(cart);
    if (updatedCart[item] != null) {
      updatedCart[item] = updatedCart[item]! - 1;
      if (updatedCart[item] == 0) {
        updatedCart.remove(item);
      }
      onCartUpdate(updatedCart);
    }
  }

  void placeOrder(BuildContext context) async {
    if (cart.isEmpty) return;

    final orderPlan = {
      'date': date,
      'items': cart.entries.map((e) {
        return {
          'name': e.key.name,
          'quantity': e.value,
          'cost': e.key.cost,
        };
      }).toList(),
    };

    final existingPlans = await SharedPrefHelper.getOrderPlans();
    existingPlans.add(orderPlan);
    await SharedPrefHelper.saveOrderPlans(existingPlans);

    cart.clear();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart.keys.elementAt(index);
                        final quantity = cart[item]!;
                        return ListTile(
                          title: Text('${item.name} (x$quantity)'),
                          subtitle: Text(
                              'Total: \$${(item.cost * quantity).toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removeFromCart(item, context),
                          ),
                        );
                      },
                    ),
            ),
            if (cart.isNotEmpty)
              ElevatedButton(
                onPressed: () => placeOrder(context),
                child: const Text('Place Order'),
              ),
          ],
        ),
      ),
    );
  }
}
