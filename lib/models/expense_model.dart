import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String accountType; // e.g., 'MoMo' or 'Card'
  final String category;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.accountType,
    required this.category,
  });

  /// Convert model to JSON (for saving to Firestore or local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'accountType': accountType,
      'category': category,
    };
  }

  /// Create model from JSON (local or API)
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      accountType: json['accountType'] ?? '',
      category: json['category'] ?? '',
    );
  }

  /// Create model from Firestore snapshot
  factory ExpenseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id, // Firestore document ID
      title: data['title'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
      accountType: data['accountType'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
