import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/chat_provider.dart';
import 'add_transaction_screen.dart';
import 'chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webs Financial Coach'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final income = transactionProvider.currentMonthIncome;
          final expenses = transactionProvider.currentMonthExpenses;
          final savings = transactionProvider.currentMonthSavings;
          final transactions = transactionProvider.currentMonthTransactions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Summary Cards
                _buildSummaryCard(income, expenses, savings),
                const SizedBox(height: 20),

                // Quick Actions
                _buildQuickActions(context),
                const SizedBox(height: 20),

                // Recent Transactions
                _buildRecentTransactions(transactions, context),
                const SizedBox(height: 20),

                // AI Insights Section
                _buildAIInsightsSection(context, income, expenses, savings),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(double income, double expenses, double savings) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'This Month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('Income', income, Colors.green),
                _buildMetricItem('Expenses', expenses, Colors.red),
                _buildMetricItem('Savings', savings, savings >= 0 ? Colors.blue : Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Add Income',
                Icons.arrow_upward,
                Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Add Expense',
                Icons.arrow_downward,
                Colors.red,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildRecentTransactions(List transactions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No transactions yet\nTap + to add your first transaction!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: transactions.reversed.take(5).map((transaction) {
                return ListTile(
                  leading: Icon(
                    transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: transaction.isIncome ? Colors.green : Colors.red,
                  ),
                  title: Text(transaction.description),
                  subtitle: Text(transaction.category),
                  trailing: Text(
                    '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAIInsightsSection(BuildContext context, double income, double expenses, double savings) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final expensesByCategory = transactionProvider.expensesByCategory;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Financial Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Simple AI analysis based on data
                    if (transactionProvider.currentMonthTransactions.isEmpty)
                      const Text(
                        'Start adding transactions to get personalized financial insights from your AI coach!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    else if (savings < 0)
                      const Text(
                        '💡 You\'re spending more than you earn this month. Consider reviewing your expenses or finding ways to increase income.',
                        style: TextStyle(fontSize: 14),
                      )
                    else if (savings / income < 0.1)
                        const Text(
                          '💡 You\'re saving less than 10% of your income. Try to increase your savings rate for better financial security.',
                          style: TextStyle(fontSize: 14),
                        )
                      else if (expensesByCategory.length == 1)
                          const Text(
                            '💡 Great job tracking your expenses! Consider categorizing them further for better insights.',
                            style: TextStyle(fontSize: 14),
                          )
                        else
                          const Text(
                            '💡 You\'re on the right track! Keep tracking your expenses and consider setting specific financial goals.',
                            style: TextStyle(fontSize: 14),
                          ),

                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to chat with pre-filled context
                        final contextMessage = _generateAIContext(
                            income, expenses, savings, expensesByCategory
                        );

                        // Navigate to chat screen first
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatScreen()),
                        ).then((_) {
                          // After chat screen is loaded, send the message
                          final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                          final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
                          chatProvider.sendMessage(contextMessage, transactionProvider: transactionProvider);
                        });
                      },
                      child: const Text('Get Personalized Advice from Webs AI Coach'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _generateAIContext(double income, double expenses, double savings, Map<String, double> expensesByCategory) {
    String context = "Based on my current financial situation: ";
    context += "I have \$$income income, \$$expenses expenses, and \$$savings savings this month. ";

    if (expensesByCategory.isNotEmpty) {
      context += "My main spending categories are: ";
      expensesByCategory.forEach((category, amount) {
        context += "$category: \$$amount, ";
      });
    }

    context += "What specific advice do you have for me to improve my financial health?";
    return context;
  }
}