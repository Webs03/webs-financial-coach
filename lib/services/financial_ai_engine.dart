class FinancialAIEngine {
  Map<String, dynamic> generateFinancialAdvice(
      String userMessage, {
        double? monthlyIncome,
        double? monthlyExpenses,
        double? monthlySavings,
        Map<String, double>? spendingCategories,
        List<Map<String, dynamic>>? recentTransactions,
      }) {

    // Analyze the user's message and financial context
    final analysis = _analyzeFinancialSituation(
      userMessage,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      monthlySavings: monthlySavings,
      spendingCategories: spendingCategories,
    );

    // Generate personalized response
    final response = _generatePersonalizedResponse(analysis, userMessage);

    return {
      'response': response,
      'analysis': analysis,
      'suggestions': _generateActionableSuggestions(analysis),
    };
  }

  Map<String, dynamic> _analyzeFinancialSituation(
      String userMessage, {
        double? monthlyIncome,
        double? monthlyExpenses,
        double? monthlySavings,
        Map<String, double>? spendingCategories,
      }) {
    final analysis = <String, dynamic>{};
    final message = userMessage.toLowerCase();

    // Financial health analysis
    if (monthlyIncome != null && monthlyExpenses != null) {
      final savingsRate = monthlySavings != null ? (monthlySavings / monthlyIncome) * 100 : 0.0;

      analysis['savingsRate'] = savingsRate;
      analysis['financialHealth'] = _calculateFinancialHealth(savingsRate.toDouble(), monthlyIncome, monthlyExpenses);

      if (spendingCategories != null && spendingCategories.isNotEmpty) {
        analysis['topSpendingCategory'] = _findTopSpendingCategory(spendingCategories);
        analysis['spendingPattern'] = _analyzeSpendingPattern(spendingCategories);
      }
    }

    // Intent analysis
    if (message.contains('save') || message.contains('saving')) {
      analysis['intent'] = 'saving';
    } else if (message.contains('invest') || message.contains('investment')) {
      analysis['intent'] = 'investing';
    } else if (message.contains('budget') || message.contains('budgeting')) {
      analysis['intent'] = 'budgeting';
    } else if (message.contains('debt') || message.contains('loan')) {
      analysis['intent'] = 'debt';
    } else if (message.contains('credit') || message.contains('score')) {
      analysis['intent'] = 'credit';
    } else if (message.contains('retire') || message.contains('pension')) {
      analysis['intent'] = 'retirement';
    } else if (message.contains('emergency') || message.contains('fund')) {
      analysis['intent'] = 'emergency_fund';
    } else {
      analysis['intent'] = 'general_advice';
    }

    return analysis;
  }

  String _generatePersonalizedResponse(Map<String, dynamic> analysis, String userMessage) {
    final intent = analysis['intent'] ?? 'general_advice';
    final financialHealth = analysis['financialHealth'] ?? 'unknown';
    final savingsRate = analysis['savingsRate'] ?? 0.0;
    final topCategory = analysis['topSpendingCategory'];

    // Base responses for different intents
    final responseTemplates = {
      'saving': _getSavingResponse(savingsRate, financialHealth, topCategory),
      'investing': _getInvestingResponse(savingsRate, financialHealth),
      'budgeting': _getBudgetingResponse(financialHealth, topCategory),
      'debt': _getDebtResponse(),
      'credit': _getCreditResponse(),
      'retirement': _getRetirementResponse(savingsRate),
      'emergency_fund': _getEmergencyFundResponse(savingsRate),
      'general_advice': _getGeneralAdviceResponse(userMessage, financialHealth),
    };

    return responseTemplates[intent] ?? _getFallbackResponse(userMessage);
  }

  // Specific response generators
  String _getSavingResponse(double savingsRate, String financialHealth, String? topCategory) {
    if (savingsRate < 10) {
      return "I notice you're saving **less than 10%** of your income. 💡 \n\n**Try starting with the 50/30/20 rule:**\n- **50%** for needs\n- **30%** for wants  \n- **20%** for savings\n\nIf ${topCategory != null ? 'you reduce your **$topCategory** spending by **15%**' : 'you cut **discretionary spending**'}, you could increase your savings significantly!";
    } else if (savingsRate >= 10 && savingsRate < 20) {
      return "**Good job saving ${savingsRate.toStringAsFixed(1)}% of your income!** 🎉 \n\nTo reach the recommended **20% savings rate**, consider:\n1) **Automating your savings**\n2) **Optimizing areas** like ${topCategory ?? 'entertainment and dining'}\n3) **Reviewing monthly subscriptions**";
    } else {
      return "**Excellent!** You're saving **${savingsRate.toStringAsFixed(1)}%** of your income - that's **above the recommended 20%!** 🏆 \n\n**Next steps:**\n1) Build a **6-month emergency fund**\n2) Explore **investment opportunities**\n3) Consider **long-term financial goals**";
    }
  }

  String _getInvestingResponse(double savingsRate, String financialHealth) {
    if (savingsRate < 10) {
      return "Before investing, focus on building your savings to at least 10-15% of your income and create a 3-month emergency fund. Once you have that foundation, we can discuss simple investment options like index funds.";
    } else if (financialHealth == 'excellent') {
      return "Great financial foundation! For investing, consider: 1) Low-cost index funds (like S&P 500 ETFs), 2) Roth IRA for tax-free growth, 3) Company 401(k) if available. Remember: diversify and think long-term!";
    } else {
      return "For beginner investing: Start with low-cost index funds or ETFs for diversification. Consider your risk tolerance and investment timeline. Never invest money you'll need within 5 years!";
    }
  }

  String _getBudgetingResponse(String financialHealth, String? topCategory) {
    final tips = [
      "Track every expense for 30 days to understand your spending patterns",
      "Use the 50/30/20 rule as a starting guideline",
      "Set specific category limits and review weekly",
      "Use cash envelopes for discretionary spending categories"
    ];

    String base = "Budgeting success starts with awareness! 📊 ";
    base += tips.join(' • ');

    if (topCategory != null) {
      base += " I notice $topCategory is a significant category - consider setting a specific monthly limit for it.";
    }

    return base;
  }

  String _getDebtResponse() {
    return "For debt management: 🎯 1) List all debts with interest rates, 2) Consider the avalanche method (highest interest first) or snowball method (smallest balance first), 3) Always pay more than minimums, 4) Avoid new debt while paying down existing ones.";
  }

  String _getCreditResponse() {
    return "Building good credit: 💳 1) Pay all bills on time, 2) Keep credit card balances below 30% of limits, 3) Don't close old accounts, 4) Have a mix of credit types, 5) Check your credit report annually for errors.";
  }

  String _getRetirementResponse(double savingsRate) {
    if (savingsRate < 15) {
      return "For retirement planning, first aim to save 15% of your income consistently. Take advantage of employer matching in 401(k) plans - it's free money! Start early - compound interest is powerful.";
    } else {
      return "Great retirement savings rate! Consider: 1) Max out employer matching, 2) Roth IRA for tax-free withdrawals, 3) Increase contributions by 1% each year, 4) Consider target-date funds for hands-off investing.";
    }
  }

  String _getEmergencyFundResponse(double savingsRate) {
    if (savingsRate < 10) {
      return "Emergency fund priority: 🛡️ Start with a \$1,000 mini-emergency fund, then build to 3-6 months of essential expenses. Cut non-essential spending temporarily to accelerate this goal.";
    } else {
      return "You're in a good position to build your emergency fund! Aim for 3-6 months of essential expenses in a high-yield savings account. This is your financial safety net!";
    }
  }

  String _getGeneralAdviceResponse(String userMessage, String financialHealth) {
    final responses = [
      "As your financial coach, I recommend starting with clear financial goals and tracking your income/expenses for 30 days to understand your cash flow.",
      "Financial success comes from consistent habits: track spending, save automatically, and educate yourself about money regularly.",
      "Remember the basics: spend less than you earn, save for emergencies, invest for the future, and protect what you've built.",
      "Great question! The foundation of financial health is understanding where your money goes and aligning spending with your values and goals."
    ];

    return "${responses[DateTime.now().millisecondsSinceEpoch % responses.length]} What specific area would you like to focus on?";
  }

  String _getFallbackResponse(String userMessage) {
    return "I understand you're asking about '$userMessage'. As your financial coach, I recommend focusing on the fundamentals: track your spending, build an emergency fund, and set clear financial goals. Would you like specific advice on saving, investing, or budgeting?";
  }

  // Helper methods
  String _calculateFinancialHealth(double savingsRate, double income, double expenses) {
    if (savingsRate >= 20) return 'excellent';
    if (savingsRate >= 10) return 'good';
    if (savingsRate > 0) return 'fair';
    if (expenses <= income) return 'needs_improvement';
    return 'critical';
  }

  String _findTopSpendingCategory(Map<String, double> categories) {
    if (categories.isEmpty) return 'unknown';
    var topEntry = categories.entries.first;
    for (final entry in categories.entries) {
      if (entry.value > topEntry.value) {
        topEntry = entry;
      }
    }
    return topEntry.key;
  }

  String _analyzeSpendingPattern(Map<String, double> categories) {
    final total = categories.values.fold(0.0, (sum, value) => sum + value);
    if (total == 0) return 'balanced';

    final topCategoryValue = categories[_findTopSpendingCategory(categories)] ?? 0.0;
    final percentage = (topCategoryValue / total) * 100;

    if (percentage > 50) return 'concentrated';
    if (percentage > 30) return 'focused';
    return 'diversified';
  }

  List<String> _generateActionableSuggestions(Map<String, dynamic> analysis) {
    final suggestions = <String>[];
    final financialHealth = analysis['financialHealth'] ?? 'unknown';
    final savingsRate = analysis['savingsRate'] ?? 0.0;

    if (savingsRate < 10) {
      suggestions.add('Increase savings rate to at least 10% of income');
      suggestions.add('Create and stick to a monthly budget');
    }

    if (financialHealth == 'critical') {
      suggestions.add('Track all expenses for 30 days');
      suggestions.add('Build a \$1,000 emergency fund immediately');
    }

    if (analysis['spendingPattern'] == 'concentrated') {
      suggestions.add('Diversify spending across more categories');
    }

    suggestions.add('Review financial goals monthly');
    suggestions.add('Automate savings transfers');

    return suggestions.take(3).toList(); // Return top 3 suggestions
  }
}