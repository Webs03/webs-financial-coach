// lib/models/budget_model.dart
class Budget {
  final String category;
  final double allocatedAmount;
  final double spentAmount;
  final DateTime month;

  Budget({
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.month,
  });
}