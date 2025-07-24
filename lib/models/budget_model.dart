import 'dart:ui';

class BudgetModel {
  final String name;
  final String description;
  final double originalSpendAmount;
  final double monthlyExpenseAmount;
  final double totalMonthlyBudget;
  final double leftAmount;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;

  BudgetModel({
    required this.name,
    required this.description,
    required this.originalSpendAmount,
    required this.monthlyExpenseAmount,
    required this.totalMonthlyBudget,
    required this.leftAmount,
    required this.color,
    required this.startDate,
    required this.endDate,
  });

  BudgetModel copyWith({
    String? name,
    String? description,
    double? originalSpendAmount,
    double? spendAmount,
    double? totalBudget,
    double? leftAmount,
    Color? color,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetModel(
      name: name ?? this.name,
      description: description ?? this.description,
      originalSpendAmount: originalSpendAmount ?? this.originalSpendAmount,
      monthlyExpenseAmount: spendAmount ?? this.monthlyExpenseAmount,
      totalMonthlyBudget: totalBudget ?? this.totalMonthlyBudget,
      leftAmount: leftAmount ?? this.leftAmount,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "originalSpendAmount": originalSpendAmount,
        "monthlyExpenseAmount": monthlyExpenseAmount,
        "totalMonthlyBudget": totalMonthlyBudget,
        "leftAmount": leftAmount,
        "color": color.value,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}
