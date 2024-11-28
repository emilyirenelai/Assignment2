import 'package:flutter/material.dart';
import 'food_selection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Food Budget App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter your budget',
              ),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Enter date (YYYY-MM-DD)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text);
                final date = dateController.text.trim();
                if (budget != null && budget > 0 && date.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodSelectionPage(budget: budget, date: date),
                    ),
                  );
                }
              },
              child: const Text('Show Affordable Food'),
            ),
          ],
        ),
      ),
    );
  }
}
