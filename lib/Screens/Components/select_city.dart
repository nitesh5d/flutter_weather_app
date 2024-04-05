import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:weather_app/Controllers/weather_controller.dart';

class SelectCity extends StatelessWidget {

  WeatherController c;

  SelectCity(this.c,{super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = Get.width;
    TextEditingController searchController = TextEditingController();

    return Center(
        child: Container(
      color: const Color(0xffFAFAFA),
      width: screenWidth * 0.9,
      height: Get.height * 0.6,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    child: TextFormField(
                      controller: searchController,
                    ),
                  ),
                ),
                Material(
                  child: IconButton.outlined(
                      onPressed: () async {
                        if (searchController.text.isNotEmpty &&
                            searchController.text.length > 2) {
                          c.citySelectLoadingVisibility.value = true;
                          c.citySelectContVisibility.value = false;
                          try {
                            c.cityListToDisplay.value = await c.dbHelper
                                .getCitiesByName(searchController.text);
                            c.citySelectContVisibility.value = true;
                          } catch (e) {
                            print('Error while getting cities by name: $e');
                          } finally {
                            c.citySelectLoadingVisibility.value = false;
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Enter atleast 3 characters");
                        }
                      },
                      icon: const Icon(Icons.search)),
                )
              ],
            ),
          ),
          Obx(() {
            return Visibility(
                visible: c.citySelectContVisibility.value,
                child: SizedBox(
                    height: 400,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey[300],
                          thickness: 0.5,
                        );
                      },
                      itemCount: c.cityListToDisplay.length,
                      itemBuilder: (context, index) {
                        return Material(
                          child: ListTile(
                            title: Text(c.cityListToDisplay[index]),
                            onTap: () {
                              c.locality = c.cityListToDisplay[index];
                              c.fetchWeather();
                              Get.back();
                            },
                          ),
                        );
                      },
                    )));
          }),
          Obx(() {
            return Visibility(
                visible: c.citySelectLoadingVisibility.value,
                child: const CircularProgressIndicator());
          })
        ],
      ),
    ));
  }
}
