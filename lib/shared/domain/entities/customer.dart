import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String id;
  final String name;
  final String phone;
  final double totalDebt;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalDebt,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      totalDebt: (json['total_debt'] as num).toDouble(),
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'total_debt': totalDebt,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  Customer copyWith({
    String? name,
    String? phone,
    double? totalDebt,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      createdAt: createdAt,
    );
  }
}
