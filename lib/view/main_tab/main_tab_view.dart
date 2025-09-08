import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:fanmint/view/add_budget/add_budget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import '../../common/color_extension.dart';
import '../calender/calender_view.dart';
import '../help/help.dart';
import '../home/home_view.dart';
import '../track_budgets/track_expense_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentTabView = const HomeView();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(children: [
        PageStorage(bucket: pageStorageBucket, child: currentTabView),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/img/bottom_bar_bg.png",
                            color: HelperFunctions.isDarkMode(context)
                                ? null
                                : UniColors.lightContainer),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTab = 0;
                                  currentTabView = const HomeView();
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/img/home.png",
                                    width: 20,
                                    height: 20,
                                    color: selectTab == 0
                                        ? HelperFunctions.isDarkMode(context)
                                            ? UniColors.secondary
                                            : UniColors.primary
                                        : TColor.gray30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selectTab == 0
                                          ? HelperFunctions.isDarkMode(context)
                                              ? UniColors.secondary
                                              : UniColors.primary
                                          : TColor.gray30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTab = 1;
                                  currentTabView = const TrackExpenseView();
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/img/budgets.png",
                                    width: 20,
                                    height: 20,
                                    color: selectTab == 1
                                        ? HelperFunctions.isDarkMode(context)
                                            ? UniColors.secondary
                                            : UniColors.primary
                                        : TColor.gray30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Track",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selectTab == 1
                                          ? HelperFunctions.isDarkMode(context)
                                              ? UniColors.secondary
                                              : UniColors.primary
                                          : TColor.gray30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTab = 2;
                                  currentTabView = CalenderView();
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/img/calendar.png",
                                    width: 20,
                                    height: 20,
                                    color: selectTab == 2
                                        ? HelperFunctions.isDarkMode(context)
                                            ? UniColors.secondary
                                            : UniColors.primary
                                        : TColor.gray30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Calendar",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selectTab == 2
                                          ? HelperFunctions.isDarkMode(context)
                                              ? UniColors.secondary
                                              : UniColors.primary
                                          : TColor.gray30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTab = 3;
                                  currentTabView = const HelpView();
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 25,
                                    color: selectTab == 3
                                        ? HelperFunctions.isDarkMode(context)
                                            ? UniColors.secondary
                                            : UniColors.primary
                                        : TColor.gray30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Help",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: selectTab == 3
                                          ? HelperFunctions.isDarkMode(context)
                                              ? UniColors.secondary
                                              : UniColors.primary
                                          : TColor.gray30,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: HelperFunctions.isDarkMode(context)
                                ? UniColors.secondary.withOpacity(0.5)
                                : UniColors.primary.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 4))
                      ], borderRadius: BorderRadius.circular(50)),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: HelperFunctions.isDarkMode(context)
                                ? UniColors.secondary
                                : UniColors.primary),
                        child: IconButton(
                            iconSize: 35,
                            color: TColor.white,
                            onPressed: () {
                              Get.to(() => AddBudgetView());
                            },
                            icon: const Icon(Icons.add)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
