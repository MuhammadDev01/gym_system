import 'package:gym_management_app/core/constants/app_constants.dart';

class MarketItemModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;
  final ItemType type;
  final bool isInStock;
  final bool sellByKilo;
  final int? kiloPrice;
  final bool sellByPiece;
  final int? piecePrice;

  MarketItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.type,
    this.isInStock = true,
    this.sellByKilo = false,
    this.kiloPrice,
    this.sellByPiece = false,
    this.piecePrice,
  });

  factory MarketItemModel.fromJson(Map<String, dynamic> json, String docId) {
    return MarketItemModel(
      id: docId,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      type: json['type'] == 'tool' ? ItemType.tool : ItemType.supplement,
      isInStock: json['isInStock'] as bool? ?? true,
      sellByKilo: json['sellByKilo'] as bool? ?? false,
      kiloPrice: json['kiloPrice'] as int?,
      sellByPiece: json['sellByPiece'] as bool? ?? false,
      piecePrice: json['piecePrice'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'type': type == ItemType.tool
          ? AppConstants.tool
          : AppConstants.supplement,
      'isInStock': isInStock,
      'sellByKilo': sellByKilo,
      if (kiloPrice != null) 'kiloPrice': kiloPrice,
      'sellByPiece': sellByPiece,
      if (piecePrice != null) 'piecePrice': piecePrice,
    };
  }

  MarketItemModel copyWith({
    String? name,
    String? description,
    String? image,
    int? price,
    ItemType? type,
    bool? isInStock,
    bool? sellByKilo,
    int? kiloPrice,
    bool? sellByPiece,
    int? piecePrice,
  }) {
    return MarketItemModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      type: type ?? this.type,
      isInStock: isInStock ?? this.isInStock,
      sellByKilo: sellByKilo ?? this.sellByKilo,
      kiloPrice: kiloPrice ?? this.kiloPrice,
      sellByPiece: sellByPiece ?? this.sellByPiece,
      piecePrice: piecePrice ?? this.piecePrice,
    );
  }
}

enum ItemType { supplement, tool }
