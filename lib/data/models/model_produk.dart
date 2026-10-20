class Product {
  final String name;
  final String image;
  final int price;
  final String category;
  final double rating;
  final int soldCount;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.category = 'Elektronik',
    this.rating = 4.8,
    this.soldCount = 120,
  });
}
