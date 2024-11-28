import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static const String foodItemsKey = 'food_items';
  static const String orderPlansKey = 'order_plans';
  
  static Future<void> saveFoodItems(List<Map<String, dynamic>> foodItems) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(foodItemsKey, jsonEncode(foodItems));
  }

  static Future<List<Map<String, dynamic>>> getFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(foodItemsKey) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }

  static Future<void> saveOrderPlans(List<Map<String, dynamic>> orderPlans) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(orderPlansKey, jsonEncode(orderPlans));
  }

  static Future<List<Map<String, dynamic>>> getOrderPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(orderPlansKey) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }
}
