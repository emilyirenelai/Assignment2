import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../database/shared_pref_helper.dart';
import 'cart_page.dart';

class FoodSelectionPage extends StatefulWidget {
  final String date;
  final double budget;

  const FoodSelectionPage({super.key, required this.date, required this.budget});

  @override
  State<FoodSelectionPage> createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends State<FoodSelectionPage> {
  late double remainingBudget;
  List<FoodItem> allFoodItems = [];
  final Map<FoodItem, int> cart = {};

  @override
  void initState() {
    super.initState();
    remainingBudget = widget.budget;
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    final items = await SharedPrefHelper.getFoodItems();
    setState(() {
      allFoodItems = items.map((item) => FoodItem.fromMap(item)).toList();
    });
  }

  void addToCart(FoodItem item) {
    if (remainingBudget >= item.cost) {
      setState(() {
        cart[item] = (cart[item] ?? 0) + 1;
        remainingBudget -= item.cost;
      });
    }
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(cart: cart, onCartUpdate: _updateCart, date: widget.date),
      ),
    );
  }

  void _updateCart(Map<FoodItem, int> updatedCart) {
    setState(() {
      cart.clear();
      cart.addAll(updatedCart);
      remainingBudget = widget.budget -
          cart.entries.fold(0.0, (sum, entry) => sum + entry.key.cost * entry.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final affordableItems =
        allFoodItems.where((item) => item.cost <= remainingBudget).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Light pink background
      appBar: AppBar(
        title: const Text('Select Food'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCartPage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allFoodItems.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining Budget: \$${remainingBudget.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  affordableItems.isEmpty
                      ? const Text(
                          'No items can be afforded with the remaining budget.',
                          style: TextStyle(fontSize: 16),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: affordableItems.length,
                            itemBuilder: (context, index) {
                              final item = affordableItems[index];
                              return ListTile(
                                title: Text(item.name),
                                subtitle: Text('\$${item.cost.toStringAsFixed(2)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => addToCart(item),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
