import '../../../../shared/domain/entities/product.dart';

/// Domain-level contract. No Firestore types allowed here —
/// keeps the domain layer testable and swappable.
abstract class ProductRepository {
  /// Live stream of all products, sorted by name.
  /// Backed by Firestore's local cache, so this emits instantly
  /// even fully offline.
  Stream<List<Product>> watchAll();

  /// One-time lookup by barcode (used at POS checkout for fast scan-to-cart).
  Future<Product?> getByBarcode(String barcode);

  Future<void> addProduct(Product product);

  Future<void> updateProduct(Product product);

  Future<void> deleteProduct(String productId);

  /// Atomically decrements stock — used by POS on checkout.
  /// Throws [InsufficientStockException] if not enough stock remains.
  Future<void> decrementStock(String productId, int quantitySold);
}
