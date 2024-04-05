import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:weather_app/Screens/select_city.dart';
import '../Controllers/weather_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    final c = Get.put(WeatherController());
    c.fetchWeather();
    c.storeCitiesToDb();

    var screenWidth = Get.width;
    var screenHeight = Get.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff252525),
        body: LiquidPullToRefresh(
          color: Color(0xff000000),
          backgroundColor: Color(0xffe5e5e5),
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 200,
          onRefresh: () => c.fetchWeather(),
          child: SizedBox(
            height: screenHeight,
            child: Stack(children: [
              Image.asset(
                'assets/images/bg.jpg',
                width: screenWidth,
              ),
              SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 30, right: 30, bottom: 40, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: Colors.blue,
                              splashColor: Colors.blue,
                              onTap: () {
                                Get.toNamed('/selectCity');
                              },
                              child: Obx(() {
                                return Text(
                                  c.locationText.value,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins'),
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx( () =>
                              Text(
                                c.greetText.value,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Domine',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() {
                        return Image.asset(
                          c.mainImage.string,
                          width: 400,
                        );
                      }),
                      Obx(() => c.returnLoading.value? c.mainTempLoadingText.value : c.mainTempText.value),
                      Obx(() => c.returnLoading.value? c.mainWeatherTypeLoadingText.value : c.mainWeatherTypeText.value),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            return Text(
                              c.mainTime.value,
                              style: const TextStyle(
                                  color: Color(0x80ffffff),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Poppins'),
                            );
                          }),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "•",
                              style: TextStyle(
                                  color: Color(0x80ffffff),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          Obx(() {
                            return Text(
                              c.mainDate.value,
                              style: const TextStyle(
                                  color: Color(0x80ffffff),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Poppins'),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/clear_sky.png',
                                  width: 40,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Sunrise",
                                      style: TextStyle(
                                          color: Color(0x86ffffff),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          fontFamily: 'Poppins'),
                                    ),
                                    Obx(() {
                                      return Text(
                                        c.sunriseTime.value,
                                        style: const TextStyle(
                                            color: Color(0xd5ffffff),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      );
                                    }),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/moon.png',
                                    width: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Sunset",
                                        style: TextStyle(
                                            color: Color(0x86ffffff),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Poppins'),
                                      ),
                                      Obx(() {
                                        return Text(
                                          c.sunsetTime.value,
                                          style: const TextStyle(
                                              color: Color(0xd5ffffff),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins'),
                                        );
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: const Divider(
                          height: 40,
                          color: Colors.white24,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/temp_low.png',
                                  width: 40,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Min Temp",
                                      style: TextStyle(
                                          color: Color(0x86ffffff),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          fontFamily: 'Poppins'),
                                    ),
                                    Obx(() {
                                      return Text(
                                        c.minTemp.value,
                                        style: const TextStyle(
                                            color: Color(0xd5ffffff),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      );
                                    }),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/temp_high.png',
                                  width: 40,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Max Temp",
                                      style: TextStyle(
                                          color: Color(0x86ffffff),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w100,
                                          fontFamily: 'Poppins'),
                                    ),
                                    Obx(() {
                                      return Text(
                                        c.maxTemp.value,
                                        style: const TextStyle(
                                            color: Color(0xd5ffffff),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      );
                                    }),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
