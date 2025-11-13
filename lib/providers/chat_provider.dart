import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];
  bool _isLoading = false;
  final AIService _aiService = AIService();

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  // Note: We'll need to pass context when calling this method
  Future<void> sendMessage(String text, {required transactionProvider}) async {
    print('📨 Sending message: $text'); // Debug print

    final userMessage = Message.user(text);
    addMessage(userMessage);

    _isLoading = true;
    notifyListeners();

    try {
      print('🔄 Getting AI advice...'); // Debug print

      // Get current financial data for context-aware responses
      final monthlyIncome = transactionProvider.currentMonthIncome;
      final monthlyExpenses = transactionProvider.currentMonthExpenses;
      final monthlySavings = transactionProvider.currentMonthSavings;
      final spendingCategories = transactionProvider.expensesByCategory;

      print('💰 Financial data - Income: \$$monthlyIncome, Expenses: \$$monthlyExpenses, Savings: \$$monthlySavings'); // Debug print

      final response = await _aiService.getFinancialAdvice(
        text,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        monthlySavings: monthlySavings,
        spendingCategories: spendingCategories,
      );

      print('✅ AI Response: $response'); // Debug print

      final assistantMessage = Message.assistant(response);
      addMessage(assistantMessage);
    } catch (e) {
      print('❌ Error: $e'); // Debug print
      final errorMessage = Message.assistant(
        "I'm here to help with financial guidance! Let me think about your question: '$text'. As a general principle, tracking expenses and setting clear savings goals are great starting points.",
      );
      addMessage(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}