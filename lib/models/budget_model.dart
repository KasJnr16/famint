import 'dart:ui';

class BudgetModel {
  final String title; // e.g. "School Transport"
  final String description; // e.g. "Cab fare to and from campus"

  final double dailyCost; // How much you spend daily on this budget
  final double monthlyPlanned; // Expected monthly cost
  final double totalBudget; // Total budget from start to end date
  final double remaining; // How much remains (can be computed dynamically)

  final Color colorTag; // Color for UI representation

  final DateTime startDate; // Start of the budget (e.g. August)
  final DateTime endDate; // End of the budget (e.g. November)

  BudgetModel({
    required this.title,
    required this.description,
    required this.dailyCost,
    required this.monthlyPlanned,
    required this.totalBudget,
    required this.remaining,
    required this.colorTag,
    required this.startDate,
    required this.endDate,
  });

  BudgetModel copyWith({
    String? title,
    String? description,
    double? dailyCost,
    double? monthlyPlanned,
    double? totalBudget,
    double? remaining,
    Color? colorTag,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BudgetModel(
      title: title ?? this.title,
      description: description ?? this.description,
      dailyCost: dailyCost ?? this.dailyCost,
      monthlyPlanned: monthlyPlanned ?? this.monthlyPlanned,
      totalBudget: totalBudget ?? this.totalBudget,
      remaining: remaining ?? this.remaining,
      colorTag: colorTag ?? this.colorTag,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "dailyCost": dailyCost,
        "monthlyPlanned": monthlyPlanned,
        "totalBudget": totalBudget,
        "remaining": remaining,
        "colorTag": colorTag.value,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
      };
}
