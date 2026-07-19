import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.products);

  @override
  Stream<List<Product>> watchAll() {
    // .snapshots() reads from the local cache first (works offline),
    // then reconciles with the server silently when connectivity returns.
    return _collection.orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Product?> getByBarcode(String barcode) async {
    final query = await _collection
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return Product.fromJson(query.docs.first.data());
  }

  @override
  Future<void> addProduct(Product product) async {
    await _collection.doc(product.id).set(product.toJson());
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _collection.doc(product.id).update(product.toJson());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _collection.doc(productId).delete();
  }

  @override
  Future<void> decrementStock(String productId, int quantitySold) async {
    // runTransaction guards against two cashiers selling the last unit
    // of a low-stock item at the same time, even offline against cache.
    await _firestore.runTransaction((txn) async {
      final docRef = _collection.doc(productId);
      final snapshot = await txn.get(docRef);

      if (!snapshot.exists) {
        throw const ServerException('Product not found');
      }

      final product = Product.fromJson(snapshot.data()!);
      final newStock = product.stockQuantity - quantitySold;

      if (newStock < 0) {
        throw InsufficientStockException(product.name);
      }

      txn.update(docRef, {'stock_quantity': newStock});
    });
  }
}
