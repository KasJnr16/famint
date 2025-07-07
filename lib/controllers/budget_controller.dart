import 'package:fanmint/common/color_extension.dart';
import 'package:fanmint/common_widget/custom_arc_180_painter.dart';
import 'package:get/get.dart';

class BudgetController extends GetxController {
  var budgetArr = <Map<String, dynamic>>[
    {
      "name": "Auto & Transport",
      "icon": "assets/img/auto_&_transport.png",
      "spend_amount": "25.99",
      "total_budget": "400",
      "left_amount": "250.01",
      "color": TColor.secondaryG
    },
    {
      "name": "Entertainment",
      "icon": "assets/img/entertainment.png",
      "spend_amount": "50.99",
      "total_budget": "600",
      "left_amount": "300.01",
      "color": TColor.secondary50
    },
    {
      "name": "Security",
      "icon": "assets/img/security.png",
      "spend_amount": "5.99",
      "total_budget": "600",
      "left_amount": "250.01",
      "color": TColor.primary10
    },
  ].obs;

  List<ArcValueModel> get arcValues => [
        ArcValueModel(color: TColor.secondaryG, value: 20),
        ArcValueModel(color: TColor.secondary, value: 45),
        ArcValueModel(color: TColor.primary10, value: 70),
      ];
}
