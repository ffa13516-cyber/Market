class Product {
  final String id;
  final String name;
  final String barcode;
  final double purchasePrice;
  final double sellingPrice;
  final double wholesalePrice;
  final int stockQuantity;
  final int lowStockThreshold;

  const Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.wholesalePrice,
    required this.stockQuantity,
    this.lowStockThreshold = 5,
  });

  bool get isLowStock => stockQuantity <= lowStockThreshold;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      wholesalePrice: (json['wholesale_price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'wholesale_price': wholesalePrice,
      'stock_quantity': stockQuantity,
      'low_stock_threshold': lowStockThreshold,
    };
  }

  Product copyWith({int? stockQuantity, double? sellingPrice}) {
    return Product(
      id: id,
      name: name,
      barcode: barcode,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      wholesalePrice: wholesalePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      lowStockThreshold: lowStockThreshold,
    );
  }
}
