import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HelperFunctions {
  HelperFunctions._();
  static Color? getColor(String value) {
    ///Define the product specific colors here and it will match the attribute colors and show the speciifc colors

    if (value == "Green") {
      return Colors.green;
    } else if (value == "Red") {
      return Colors.red;
    } else if (value == "Blue") {
      return Colors.blue;
    } else if (value == "Pink") {
      return Colors.pink;
    } else if (value == "Grey") {
      return Colors.grey;
    } else if (value == "Purple") {
      return Colors.purple;
    } else if (value == "Black") {
      return Colors.black;
    } else if (value == "Yello") {
      return Colors.yellow;
    } else if (value == "White") {
      return Colors.white;
    } else if (value == "Brown") {
      return Colors.brown;
    } else if (value == "Indigo") {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return "${text.substring(0, maxLength)}...";
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime? date,
      {String formate = "dd MMM yyyy"}) {
    if (date != null) {
      return DateFormat(formate).format(date);
    }
    return "No Date";
  }

  static String getFormattedTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm()
        .format(dateTime); // Format to 'h:mm a' (e.g., 8:30 AM)
  }

  static String getChatTime(Timestamp timestamp) {
    DateTime messageTime = timestamp.toDate();
    DateTime now = DateTime.now();

    Duration difference = now.difference(messageTime);

    if (difference.isNegative) {
      return "Just now"; // Handles future timestamps
    }

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if (days > 0) {
      return "$days ${days == 1 ? 'day' : 'days'} ago";
    } else if (hours > 0) {
      return "$hours ${hours == 1 ? 'hour' : 'hours'} ago";
    } else if (minutes > 0) {
      return "$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago";
    } else {
      return "Just now";
    }
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<String> convertToStrings(List<dynamic> types) {
    return types.map((type) {
      final raw = type.toString().split('.').last;
      final spaced = raw.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
        return '${match.group(1)} ${match.group(2)}';
      });
      return spaced.split(' ').map((word) => word.capitalizeFirst!).join(' ');
    }).toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(
        children: rowChildren,
      ));
    }
    return wrappedList;
  }
}
