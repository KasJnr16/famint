class ExpenseModel {
  final String title;
  final double amount;
  final DateTime date;
  final String accountType; // e.g., 'MoMo' or 'Card'
  final String category;

  ExpenseModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.accountType,
    required this.category,
  });
}
