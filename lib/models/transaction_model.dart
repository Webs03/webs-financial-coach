// lib/models/transaction_model.dart
class Transaction {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final bool isIncome;
  final String type;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.isIncome,
    required this.type,
  });
}