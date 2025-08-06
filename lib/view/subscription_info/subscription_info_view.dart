import 'package:dotted_border/dotted_border.dart';
import 'package:fanmint/models/budget_model.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fanmint/common_widget/secondary_boutton.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/color_extension.dart';
import '../../common_widget/item_row.dart';

class SubscriptionInfoView extends StatefulWidget {
  final BudgetModel budget;
  const SubscriptionInfoView({super.key, required this.budget});

  @override
  State<SubscriptionInfoView> createState() => _SubscriptionInfoViewState();
}

class _SubscriptionInfoViewState extends State<SubscriptionInfoView> {
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xff282833).withOpacity(0.9)
                      : UniColors.light,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      height: media.width * 0.9,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: dark ? TColor.gray70 : UniColors.light,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset("assets/img/dorp_down.png",
                                    width: 20,
                                    height: 20,
                                    color:
                                        dark ? TColor.white : UniColors.dark),
                              ),
                              Text(
                                "Details",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset("assets/img/Trash.png",
                                    width: 25,
                                    height: 25,
                                    color:
                                        dark ? TColor.white : UniColors.dark),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Image.asset(
                          //   widget.item["icon"],
                          //   width: media.width * 0.25,
                          //   height: media.width * 0.25,
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.budget.title,
                            style: TextStyle(
                                color: dark ? TColor.white : UniColors.dark,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "GHC ${widget.budget.totalBudget}",
                            style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: TColor.border.withOpacity(0.1),
                              ),
                              color: TColor.gray60.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ItemRow(
                                  title: "Name",
                                  value: widget.budget.title,
                                ),
                                ItemRow(
                                  title: "Description",
                                  value: widget.budget.description.isEmpty
                                      ? "No description provided"
                                      : widget.budget.description,
                                ),
                                ItemRow(
                                  title: "Start Date",
                                  value: DateFormat.yMMMMEEEEd()
                                      .format(widget.budget.startDate),
                                ),
                                ItemRow(
                                  title: "End Date",
                                  value: DateFormat.yMMMMEEEEd()
                                      .format(widget.budget.endDate),
                                ),
                                ItemRow(
                                  title: "Currency",
                                  value: "GHANA (GHC)",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SecondaryButton(
                              title: "Close", onPressed: () => Get.back())
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 4, right: 4),
                height: media.width * 0.9 + 15,
                alignment: Alignment.bottomCenter,
                child: Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: TColor.gray,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Expanded(
                      child: DottedBorder(
                    dashPattern: const [5, 10],
                    padding: EdgeInsets.zero,
                    strokeWidth: 1,
                    radius: const Radius.circular(16),
                    color: TColor.gray,
                    child: SizedBox(
                      height: 0,
                    ),
                  )),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: TColor.gray,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
