import 'package:get/get.dart';

class CardsController extends GetxController {
  final subArr = <Map<String, dynamic>>[
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": "5.99"},
    {
      "name": "YouTube Premium",
      "icon": "assets/img/youtube_logo.png",
      "price": "18.99"
    },
    {
      "name": "Microsoft OneDrive",
      "icon": "assets/img/onedrive_logo.png",
      "price": "29.99"
    },
    {
      "name": "NetFlix",
      "icon": "assets/img/netflix_logo.png",
      "price": "15.00"
    },
  ].obs;

  final carArr = <Map<String, dynamic>>[
    {
      "name": "member 1",
      "number": "**** **** **** 2197",
      "month_year": "08/27"
    },
    {
      "name": "member 2",
      "number": "**** **** **** 2198",
      "month_year": "09/27"
    },
    {
      "name": "member 3",
      "number": "**** **** **** 2297",
      "month_year": "07/27"
    },
    {
      "name": "member 4",
      "number": "**** **** **** 2397",
      "month_year": "05/27"
    },
  ].obs;
}
