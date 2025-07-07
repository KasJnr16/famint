// Controller (calendar_controller.dart)
import 'dart:math';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:get/get.dart';

class CalendarController extends GetxController {
  final calendarAgendaController = CalendarAgendaController();
  final selectedDate = DateTime.now().obs;
  final random = Random();

  final subArr = <Map<String, dynamic>>[
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": "5.99"},
    {"name": "YouTube Premium", "icon": "assets/img/youtube_logo.png", "price": "18.99"},
    {"name": "Microsoft OneDrive", "icon": "assets/img/onedrive_logo.png", "price": "29.99"},
    {"name": "NetFlix", "icon": "assets/img/netflix_logo.png", "price": "15.00"}
  ].obs;

  List<DateTime> get events => List.generate(
        100,
        (index) => DateTime.now().subtract(Duration(days: index * random.nextInt(5))),
      );

  void updateSelectedDate(DateTime date) => selectedDate.value = date;
}
