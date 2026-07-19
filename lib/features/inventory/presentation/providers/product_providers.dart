import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/entities/product.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

/// Wires up the repository implementation. Swap this single line
/// if you ever need a fake/mock repository for tests.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(FirebaseFirestore.instance);
});

/// Live product list — the UI watches this via AsyncValue (.when).
/// Renders instantly from Firestore's local cache, even offline.
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchAll();
});

/// Search/filter text typed by the cashier in the product list screen.
final productSearchQueryProvider = StateProvider<String>((ref) => '');

/// Derived, filtered list — combines the live stream with the search box.
/// Kept as a separate provider so widgets only rebuild when the *filtered*
/// result actually changes, not on every keystroke against the raw stream.
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsStreamProvider);
  final query = ref.watch(productSearchQueryProvider).trim().toLowerCase();

  return productsAsync.whenData((products) {
    if (query.isEmpty) return products;
    return products
        .where((p) =>
            p.name.toLowerCase().contains(query) || p.barcode.contains(query))
        .toList();
  });
});
