import 'package:flutter/material.dart';
import '../database/shared_pref_helper.dart';

class OrderPlansPage extends StatefulWidget {
  const OrderPlansPage({super.key});

  @override
  State<OrderPlansPage> createState() => _OrderPlansPageState();
}

class _OrderPlansPageState extends State<OrderPlansPage> {
  List<Map<String, dynamic>> orderPlans = [];

  @override
  void initState() {
    super.initState();
    loadOrderPlans();
  }

  Future<void> loadOrderPlans() async {
    final plans = await SharedPrefHelper.getOrderPlans();
    debugPrint('Loaded Order Plans: $plans');
    setState(() {
      orderPlans = plans;
    });
  }

  Future<void> saveOrderPlans() async {
    await SharedPrefHelper.saveOrderPlans(orderPlans);
    setState(() {});
  }

  Future<void> deleteOrderPlan(int index) async {
    orderPlans.removeAt(index);
    await saveOrderPlans();
  }

  double calculateTotalCost(List<dynamic> items) {
    return items.fold(0.0, (sum, item) {
      final cost = double.tryParse(item['cost'].toString()) ?? 0.0;
      final quantity = double.tryParse(item['quantity'].toString()) ?? 0.0;
      return sum + (cost * quantity);
    });
  }

  void modifyItem(int planIndex, int itemIndex, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        orderPlans[planIndex]['items'][itemIndex]['quantity'] = newQuantity;
      } else {
        orderPlans[planIndex]['items'].removeAt(itemIndex);
      }
    });
    saveOrderPlans();
  }

  void addItem(int planIndex) {
    final nameController = TextEditingController();
    final costController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Item Cost'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final cost = double.tryParse(costController.text.trim()) ?? 0.0;
              final quantity = int.tryParse(quantityController.text.trim()) ?? 0;

              if (name.isNotEmpty && cost > 0 && quantity > 0) {
                setState(() {
                  orderPlans[planIndex]['items'].add({
                    'name': name,
                    'cost': cost,
                    'quantity': quantity,
                  });
                });
                saveOrderPlans();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Plans')),
      body: ListView.builder(
        itemCount: orderPlans.length,
        itemBuilder: (context, index) {
          final plan = orderPlans[index];
          final items = plan['items'] as List;
          final totalCost = calculateTotalCost(items);

          return ExpansionTile(
            title: Text('Date: ${plan['date']}'),
            subtitle: Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteOrderPlan(index),
            ),
            children: [
              ...items.asMap().entries.map((entry) {
                final itemIndex = entry.key;
                final item = entry.value;
                final cost = double.tryParse(item['cost'].toString()) ?? 0.0;
                final quantity = int.tryParse(item['quantity'].toString()) ?? 0;

                return ListTile(
                  title: Text('${item['name']}'),
                  subtitle: Text(
                    '$quantity x \$${cost.toStringAsFixed(2)} = \$${(quantity * cost).toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          modifyItem(index, itemIndex, quantity - 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          modifyItem(index, itemIndex, quantity + 1);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          modifyItem(index, itemIndex, 0);
                        },
                      ),
                    ],
                  ),
                );
              }),
              ListTile(
                title: const Text('Add New Item'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addItem(index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
