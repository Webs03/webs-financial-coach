import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart' as local;
import '../services/firebase_service.dart';

class TransactionProvider with ChangeNotifier {
  final List<local.Transaction> _transactions = [];
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  List<local.Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Add all the missing getter methods
  List<local.Transaction> get currentMonthTransactions {
    final now = DateTime.now();
    return _transactions.where((transaction) {
      return transaction.date.month == now.month &&
          transaction.date.year == now.year;
    }).toList();
  }

  double get currentMonthIncome {
    return currentMonthTransactions
        .where((transaction) => transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get currentMonthExpenses {
    return currentMonthTransactions
        .where((transaction) => !transaction.isIncome)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get currentMonthSavings {
    return currentMonthIncome - currentMonthExpenses;
  }

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

  TransactionProvider() {
    _initializeAuth();
    _loadTransactions();
  }

  Future<void> _initializeAuth() async {
    try {
      await _firebaseService.signInAnonymously();
      print('✅ User signed in: ${_firebaseService.currentUser?.uid}');
      print('🔥 Firebase connected successfully!');
    } catch (e) {
      print('❌ Firebase auth error: $e');
    }
  }

  void _loadTransactions() {
    _firebaseService.getTransactions().listen((transactions) {
      _transactions.clear();
      _transactions.addAll(transactions);
      notifyListeners();
      print('📊 Loaded ${transactions.length} transactions');
    });
  }

  void addTransaction(local.Transaction transaction) async {
    _transactions.add(transaction);
    notifyListeners();

    // Save to Firebase
    await _firebaseService.saveTransaction(transaction);
    print('💾 Saved transaction to Firebase');
  }

  void deleteTransaction(String id) async {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();

    // Delete from Firebase
    await _firebaseService.deleteTransaction(id);
    print('🗑️ Deleted transaction from Firebase');
  }

  void clearAllTransactions() {
    _transactions.clear();
    notifyListeners();
  }
}