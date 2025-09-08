import 'package:fanmint/common_widget/animation_loader.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/add_budget/add_budget_view.dart';
import 'package:fanmint/view/subscription_info/subscription_info_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_agenda/calendar_agenda.dart';

import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/subscription_cell.dart';
import '../../controllers/calendar_controller.dart';

class CalenderView extends StatelessWidget {
  CalenderView({super.key});

  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Obx(() => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        dark ? TColor.gray70.withOpacity(0.5) : UniColors.light,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Subs\nSchedule",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${controller.budgetList.length} Expense(s) for today",
                                    style: TextStyle(
                                        color: dark ? TColor.gray30 : null,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      controller.calendarAgendaController
                                          .openCalender();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: TColor.border.withOpacity(0.1),
                                        ),
                                        color: dark
                                            ? TColor.gray60.withOpacity(0.2)
                                            : UniColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Text(
                                              DateTime.now()
                                                  .toLocal()
                                                  .monthName,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                          Icon(Icons.expand_more, size: 16.0),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        CalendarAgenda(
                          controller: controller.calendarAgendaController,
                          backgroundColor: Colors.transparent,
                          dateColor: dark ? TColor.white : UniColors.dark,
                          fullCalendarBackgroundColor: TColor.gray80,
                          locale: 'en',
                          weekDay: WeekDay.short,
                          fullCalendarDay: WeekDay.short,
                          selectedDateColor: TColor.white,
                          initialDate: controller.selectedDate.value,
                          calendarEventColor:
                              dark ? TColor.secondary : TColor.gray,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 140)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 140)),
                          events: controller.events,
                          onDateSelected: controller.updateSelectedDate,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.15),
                            ),
                            color: dark
                                ? TColor.gray60.withOpacity(0.2)
                                : UniColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          selectDecoration: BoxDecoration(
                            border: Border.all(
                              color: TColor.border.withOpacity(0.15),
                            ),
                            color: dark ? TColor.gray60 : TColor.primary5,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          selectedEventLogo: _eventDot(dark),
                          eventLogo: _eventDot(dark),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Month Summary
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateTime.now().toLocal().monthName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Obx(() => Text(
                                "GHC ${controller.dailyTotal.value.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
                            style: TextStyle(
                              color: TColor.gray30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "amount",
                            style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                Obx(() {
                  final budgets = controller.budgetList;
                  if (budgets.isEmpty) {
                    return UniAnimationLoaderWidget(
                      lottie: 'assets/lottie/empty_box.json',
                      text: "No scheduled expenses",
                      showAction: true,
                      actionText: "Add some",
                      onActionPressed: () => Get.to(() => AddBudgetView()),
                    );
                  }

                  /// Subscriptions Grid
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1),
                    itemCount: controller.budgetList.length,
                    itemBuilder: (context, index) {
                      final budget = controller.budgetList[index];
                      return SubScriptionCell(
                        budget: budget,
                        onPressed: () =>
                            Get.to(() => SubscriptionInfoView(budget: budget)),
                      );
                    },
                  );
                }),

                const SizedBox(height: 130),
              ],
            )),
      ),
    );
  }

  Widget _eventDot(bool dark) => Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: dark ? TColor.secondary : UniColors.dark,
          borderRadius: BorderRadius.circular(3),
        ),
      );
}
