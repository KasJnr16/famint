// Controller (calendar_controller.dart)
import 'dart:math';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:fanmint/controllers/budget_controller.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:get/get.dart';

class CalendarController extends GetxController {
  final calendarAgendaController = CalendarAgendaController();
  final selectedDate = DateTime.now().obs;
  final random = Random();

  final budgetList = <BudgetModel>[].obs;
  final dailyTotal = 0.0.obs;

  final budgetController = BudgetController.instance;

  @override
  void onInit() {
    super.onInit();
    _loadExpensesForSelectedDate();
  }

  List<DateTime> get events => List.generate(
        100,
        (index) =>
            DateTime.now().subtract(Duration(days: index * random.nextInt(5))),
      );

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    _loadExpensesForSelectedDate();
  }

  void _loadExpensesForSelectedDate() {
    final selected = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
    );

    final List<BudgetModel> allBudgets = budgetController.budgetList;

    final matchingBudgets = allBudgets.where((budget) {
      final start = DateTime(
          budget.startDate.year, budget.startDate.month, budget.startDate.day);
      final end = DateTime(
          budget.endDate.year, budget.endDate.month, budget.endDate.day);
      return selected.isAtSameMomentAs(start) ||
          selected.isAtSameMomentAs(end) ||
          (selected.isAfter(start) && selected.isBefore(end));
    }).toList();

    budgetList.value = matchingBudgets;
    dailyTotal.value = matchingBudgets.fold(0.0, (sum, b) => sum + b.dailyCost);
  }
}

extension MonthNameExtension on DateTime {
  String get monthName {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[this.month - 1];
  }
}
