
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // 'sol', 'optico', 'ninos', 'accesorio'
  final String imageUrl;
  final ProductSpecs? specs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.specs,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'specs': specs?.toMap(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      specs: map['specs'] != null ? ProductSpecs.fromMap(map['specs']) : null,
    );
  }
}

class ProductSpecs {
  final double bridge; // Puente
  final double width; // Cristal/Ancho
  final double temple; // Patilla

  ProductSpecs({
    required this.bridge,
    required this.width,
    required this.temple,
  });

  Map<String, dynamic> toMap() {
    return {
      'bridge': bridge,
      'width': width,
      'temple': temple,
    };
  }

  factory ProductSpecs.fromMap(Map<String, dynamic> map) {
    return ProductSpecs(
      bridge: (map['bridge'] ?? 0).toDouble(),
      width: (map['width'] ?? 0).toDouble(),
      temple: (map['temple'] ?? 0).toDouble(),
    );
  }
}
