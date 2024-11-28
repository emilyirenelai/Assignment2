class FoodItem {
  final String name;
  final double cost;

  FoodItem({required this.name, required this.cost});

  Map<String, dynamic> toMap() {
    return {'name': name, 'cost': cost};
  }

  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'],
      cost: map['cost'],
    );
  }
}
