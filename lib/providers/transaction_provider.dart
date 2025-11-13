import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Get transactions for current month
  List<Transaction> get currentMonthTransactions {
    final now = DateTime.now();
    return _transactions.where((transaction) {
      return transaction.date.month == now.month &&
          transaction.date.year == now.year;
    }).toList();
  }

  // Add new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Delete transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  // Get total income for current month
  double get currentMonthIncome {
    return currentMonthTransactions
        .where((transaction) => transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Get total expenses for current month
  double get currentMonthExpenses {
    return currentMonthTransactions
        .where((transaction) => !transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Get net savings for current month
  double get currentMonthSavings {
    return currentMonthIncome - currentMonthExpenses;
  }

  // Get transactions by category
  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryMap = {};

    for (final transaction in currentMonthTransactions) {
      if (!transaction.isIncome) {
        categoryMap[transaction.category] =
            (categoryMap[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return categoryMap;
  }
}