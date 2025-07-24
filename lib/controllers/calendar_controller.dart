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

  final subArr = <BudgetModel>[].obs;
  final dailyTotal = 0.0.obs;

  final budgetController = BudgetController.instance;

  @override
  void onInit() {
    super.onInit();
    _loadExpensesForSelectedDate();
    // Listen to changes in the budgetController's expensesList
    ever<List<BudgetModel>>(budgetController.expensesList, (_) {
      _loadExpensesForSelectedDate();
    });
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
    final date = selectedDate.value;
    final matchedExpenses = budgetController.expensesList.where((expense) {
      return !date.isBefore(expense.startDate) &&
          !date.isAfter(expense.endDate);
    }).toList();

    subArr.value = matchedExpenses;

    dailyTotal.value = matchedExpenses.fold(
      0.0,
      (sum, e) => sum + e.originalSpendAmount,
    );
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
