import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/Controllers/weather_controller.dart';

class SelectCity extends StatelessWidget {
  SelectCity({super.key});

  var c = Get.find<WeatherController>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    c.getCityList();
    c.citySelectLoadingVisibility.value = true;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff101010),
          appBar: AppBar(
            backgroundColor: Color(0xff252525),
            toolbarHeight: 65,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: "Enter name of any City",
                          hintStyle: TextStyle(color: Color(0x81ffffff)),
                        ),
                        maxLines: 1,
                        controller: searchController,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: ElevatedButton(
                      onPressed: () {
                        searchFunc();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.orange[600]),
                      child: const Icon(Icons.search)),
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Obx(() {
                return Visibility(
                    visible: c.citySelectLoadingVisibility.value,
                    child: CircularProgressIndicator(
                      color: Colors.orange[600],
                    ));
              }),
              Expanded(
                child: Obx(() {
                  return Visibility(
                      visible: c.citySelectContVisibility.value,
                      child: ListView.builder(
                        // padding: EdgeInsets.only(top: 3, right: 2, left: 2),
                        itemCount: c.cityListToDisplay.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                title: Text(c.cityListToDisplay[index]),
                                tileColor: Color(0xff1f1f1f),
                                textColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                minVerticalPadding: 20,
                                onTap: () {
                                  c.locality = c.cityListToDisplay[index];
                                  c.fetchWeather();
                                  Get.back();
                                },
                              ),
                            ),
                          );
                        },
                      ));
                }),
              ),
            ],
          )),
    );
  }

  void searchFunc() async {
    if (searchController.text.isNotEmpty && searchController.text.length > 2) {
      c.citySelectLoadingVisibility.value = true;
      c.citySelectContVisibility.value = false;
      List<Map<String, dynamic>> list = [];
      try {
        list = await c.dbHelper.getCitiesByName(searchController.text);
        c.cityListToDisplay.clear();
        for (int i = 0; i < list.length; i++) {
          c.cityListToDisplay.add(list[i]['name']);
        }
        c.citySelectContVisibility.value = true;
      } catch (e) {
        print('Error while getting cities by name: $e');
      } finally {
        c.citySelectLoadingVisibility.value = false;
      }
    } else {
      Fluttertoast.showToast(msg: "Enter atleast 3 characters");
    }
  }
}
