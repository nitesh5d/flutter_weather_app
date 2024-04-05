import 'package:get/get.dart';
import 'package:weather_app/Screens/home.dart';
import 'package:weather_app/Screens/not_found.dart';
import 'package:weather_app/Screens/select_city.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const Home(),
    ),
    GetPage(
        name: '/selectCity',
        page: () => SelectCity(),
        transition: Transition.leftToRight)
  ];

  static GetPage notFound = GetPage(name: '/404', page: () => const NotFound());
}
