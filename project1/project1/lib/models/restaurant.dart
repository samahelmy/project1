class Restaurant {
  final String name;
  final String price;
  final String location;
  final String description;

  Restaurant({
    required this.name,
    required this.price,
    required this.location,
    this.description = '', // Optional with default empty string
  });
}
