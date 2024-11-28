import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/order_plans_page.dart';
import './database/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFoodItems();
  runApp(const MyApp());
}

Future<void> initializeFoodItems() async {
  final existingItems = await SharedPrefHelper.getFoodItems();
  if (existingItems.isEmpty) {
    final initialFoodItems = [
      {'name': 'Lobster', 'cost': 25.0},
      {'name': 'Sushi', 'cost': 20.0},
      {'name': 'BBQ Ribs', 'cost': 18.0},
      {'name': 'Steak', 'cost': 15.0},
      {'name': 'Fish and Chips', 'cost': 14.0},
      {'name': 'Curry', 'cost': 13.0},
      {'name': 'Ramen', 'cost': 12.0},
      {'name': 'Pasta', 'cost': 12.0},
      {'name': 'Chicken Wings', 'cost': 11.0},
      {'name': 'Spaghetti', 'cost': 10.0},
      {'name': 'Burger', 'cost': 10.0},
      {'name': 'Dumplings', 'cost': 9.0},
      {'name': 'Tacos', 'cost': 9.0},
      {'name': 'Waffles', 'cost': 8.0},
      {'name': 'Pizza', 'cost': 8.0},
      {'name': 'Falafel', 'cost': 8.0},
      {'name': 'Pancakes', 'cost': 7.0},
      {'name': 'Salad', 'cost': 7.0},
      {'name': 'Nachos', 'cost': 6.0},
      {'name': 'Sandwich', 'cost': 6.0},
      {'name': 'Ice Cream', 'cost': 5.0},
      {'name': 'Hot Dog', 'cost': 4.0},
      {'name': 'Fries', 'cost': 3.0},
    ];
    await SharedPrefHelper.saveFoodItems(initialFoodItems);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    OrderPlansPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Order Plans',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
