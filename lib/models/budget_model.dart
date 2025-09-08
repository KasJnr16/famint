import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final String title; // e.g. "School Transport"
  final String description; // e.g. "Cab fare to and from campus"

  final double dailyCost; // How much you spend daily on this budget
  final double monthlyPlanned; // Expected monthly cost
  final double totalBudget; // Total budget from start to end date
  final double remaining; // How much remains (can be computed dynamically)

  final Color colorTag; // Color for UI representation
  final List<String>? confirmedDates;

  final DateTime startDate; // Start of the budget (e.g. August)
  final DateTime endDate; // End of the budget (e.g. November)

  BudgetModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dailyCost,
    required this.monthlyPlanned,
    required this.totalBudget,
    required this.remaining,
    required this.colorTag,
    required this.startDate,
    required this.endDate,
    this.confirmedDates,
  });

  BudgetModel copyWith(
      {String? id,
      String? title,
      String? description,
      double? dailyCost,
      double? monthlyPlanned,
      double? totalBudget,
      double? remaining,
      Color? colorTag,
      DateTime? startDate,
      DateTime? endDate,
      List<String>? confirmedDates}) {
    return BudgetModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dailyCost: dailyCost ?? this.dailyCost,
        monthlyPlanned: monthlyPlanned ?? this.monthlyPlanned,
        totalBudget: totalBudget ?? this.totalBudget,
        remaining: remaining ?? this.remaining,
        colorTag: colorTag ?? this.colorTag,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        confirmedDates: confirmedDates ?? this.confirmedDates);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dailyCost": dailyCost,
        "monthlyPlanned": monthlyPlanned,
        "totalBudget": totalBudget,
        "remaining": remaining,
        "colorTag": colorTag.value,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "confirmedDates": confirmedDates,
      };

  /// Create BudgetModel from Firestore snapshot
  factory BudgetModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dailyCost: (data['dailyCost'] as num?)?.toDouble() ?? 0.0,
      monthlyPlanned: (data['monthlyPlanned'] as num?)?.toDouble() ?? 0.0,
      totalBudget: (data['totalBudget'] as num?)?.toDouble() ?? 0.0,
      remaining: (data['remaining'] as num?)?.toDouble() ?? 0.0,
      colorTag: Color((data['colorTag'] as int?) ?? 0xFFFFFFFF),
      startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(data['endDate'] ?? '') ?? DateTime.now(),
      confirmedDates: (data['confirmedDates'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
