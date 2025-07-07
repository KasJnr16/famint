import 'package:card_swiper/card_swiper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fanmint/controllers/card_controller.dart';
import 'package:fanmint/utility/constants/colors.dart';
import 'package:fanmint/utility/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/view/settings/settings_view.dart';

class CardsView extends StatelessWidget {
  const CardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CardsController());
    final swiperController = SwiperController();

    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColor.gray : UniColors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 600,
                  child: Swiper(
                    itemCount: controller.carArr.length,
                    customLayoutOption:
                        CustomLayoutOption(startIndex: -1, stateCount: 3)
                          ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
                          ..addTranslate([
                            const Offset(-370.0, -40.0),
                            Offset.zero,
                            const Offset(370.0, -40.0),
                          ]),
                    fade: 1.0,
                    scale: 0.8,
                    itemWidth: 232.0,
                    itemHeight: 350,
                    controller: swiperController,
                    layout: SwiperLayout.STACK,
                    viewportFraction: 0.8,
                    itemBuilder: (context, index) {
                      final cObj = controller.carArr[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: TColor.gray70,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4)
                          ],
                        ),
                        child: Stack(fit: StackFit.expand, children: [
                          Image.asset("assets/img/card_blank.png",
                              width: 232.0, height: 350),
                          Column(
                            children: [
                              const SizedBox(height: 30),
                              Image.asset("assets/img/mastercard_logo.png",
                                  width: 50),
                              const SizedBox(height: 8),
                              Text("Virtual Card",
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 115),
                              Text(cObj["name"],
                                  style: TextStyle(
                                      color: TColor.gray20,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text(cObj["number"],
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text(cObj["month_year"],
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ]),
                      );
                    },
                    autoplayDisableOnInteraction: false,
                    axisDirection: AxisDirection.right,
                  ),
                )),
            Column(
              children: [
                SafeArea(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Credit Cards", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SettingsView()),
                              );
                            },
                            icon: Image.asset("assets/img/settings.png",
                                width: 25,
                                height: 65,
                                color: dark ? TColor.white : UniColors.dark),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 380),
                Text("Subscriptions",
                    style: TextStyle(
                        color: TColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: controller.subArr.map((sObj) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child:
                              Image.asset(sObj["icon"], width: 40, height: 40),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: 40),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color:
                        dark ? TColor.gray70.withOpacity(0.5) : UniColors.light,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {},
                          child: DottedBorder(
                            dashPattern: const [5, 4],
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(16),
                            color: dark
                                ? TColor.border.withOpacity(0.1)
                                : UniColors.darkGrey,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add new tracking",
                                      style: TextStyle(
                                          color: TColor.gray40,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset("assets/img/add.png",
                                      width: 12,
                                      height: 12,
                                      color: TColor.gray40)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
