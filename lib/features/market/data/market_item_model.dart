class MarketModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;
  final ItemType type;

  MarketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.type,
  });
}

enum ItemType { supplement, tool }
