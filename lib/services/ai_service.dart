import 'financial_ai_engine.dart'; // Add this import

class AIService {
  final FinancialAIEngine _financialEngine = FinancialAIEngine();

  Future<String> getFinancialAdvice(
      String userMessage, {
        double? monthlyIncome,
        double? monthlyExpenses,
        double? monthlySavings,
        Map<String, double>? spendingCategories,
      }) async {

    try {
      // Use our smart financial engine
      final result = _financialEngine.generateFinancialAdvice(
        userMessage,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        monthlySavings: monthlySavings,
        spendingCategories: spendingCategories,
      );

      return result['response'] as String;

    } catch (e) {
      // Fallback responses that always work
      return _getFallbackResponse(userMessage);
    }
  }

  String _getFallbackResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      return "Hello! I'm Webs Financial Coach, your AI assistant for financial guidance. I can help with saving strategies, investment basics, budgeting, debt management, and financial planning. What would you like to know?";
    }

    if (message.contains('thank')) {
      return "You're welcome! Remember, financial success is a journey. Keep tracking your progress and don't hesitate to ask more questions!";
    }

    return "Thanks for your question about financial matters! As your coach, I recommend starting with clear financial goals, tracking your income and expenses, and building an emergency fund. What specific area would you like to explore?";
  }
}