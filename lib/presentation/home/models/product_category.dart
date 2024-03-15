enum ProductCategory {
  none('None'),
  drink('Minuman'),
  food('Makanan'),
  snack('Snack');

  final String value;
  const ProductCategory(this.value);

  bool get isFood => this == ProductCategory.food;
  bool get isDrink => this == ProductCategory.drink;
  bool get isSnack => this == ProductCategory.snack;

  factory ProductCategory.fromValue(String value) {
    return values.firstWhere(
      (element) => element.value == value,
      orElse: () => ProductCategory.none,
    );
  }
}
