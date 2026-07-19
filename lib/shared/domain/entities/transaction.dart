import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentType { cash, credit, split }

class TransactionItem {
  final String productId;
  final String productName; // denormalized for fast receipt rendering
  final int qty;
  final double price;

  const TransactionItem({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
  });

  double get lineTotal => qty * price;

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String? ?? '',
      qty: (json['qty'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'qty': qty,
      'price': price,
    };
  }
}

class InvoiceTransaction {
  final String id;
  final String? customerId; // nullable -> walk-in cash sale
  final double totalAmount;
  final double paidAmount;
  final double debtAmount;
  final PaymentType paymentType;
  final List<TransactionItem> items;
  final DateTime timestamp;

  const InvoiceTransaction({
    required this.id,
    this.customerId,
    required this.totalAmount,
    required this.paidAmount,
    required this.debtAmount,
    required this.paymentType,
    required this.items,
    required this.timestamp,
  });

  factory InvoiceTransaction.fromJson(Map<String, dynamic> json) {
    return InvoiceTransaction(
      id: json['id'] as String,
      customerId: json['customer_id'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      debtAmount: (json['debt_amount'] as num).toDouble(),
      paymentType: PaymentType.values.firstWhere(
        (e) => e.name == (json['payment_type'] as String? ?? 'cash'),
        orElse: () => PaymentType.cash,
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'debt_amount': debtAmount,
      'payment_type': paymentType.name,
      'items': items.map((e) => e.toJson()).toList(),
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
