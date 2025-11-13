class AppConstants {
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Gift',
    'Other Income'
  ];

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Other Expenses'
  ];

  static const List<String> allCategories = [
    ...incomeCategories,
    ...expenseCategories,
  ];
}