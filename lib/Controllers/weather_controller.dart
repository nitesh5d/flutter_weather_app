// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/DB/db_helper.dart';
import 'dart:convert';
import '../Models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherController extends GetConnect {
  var mainImage = 'assets/images/normal weather.png'.obs;

  RxString mainTemp = ''.obs;
  RxString mainWeatherType = ''.obs;
  RxString mainDate = ''.obs;
  RxString mainTime = ''.obs;
  RxString sunriseTime = ''.obs;
  RxString sunsetTime = ''.obs;
  RxString minTemp = ''.obs;
  RxString maxTemp = ''.obs;  RxString locationText = ''.obs;
  RxString greetText = ''.obs;

  String locality = '';

  RxBool citySelectLoadingVisibility = false.obs;
  RxBool citySelectContVisibility = false.obs;

  Rx<Animate> mainTempText = Text(
    "",
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'),
  ).animate().slide(duration: Duration(seconds: 4)).obs;
  Rx<Animate> mainWeatherTypeText = Text(
    "",
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'),
  ).animate().slide(duration: Duration(seconds: 4)).obs;
  Rx<Animate> mainTempLoadingText = Text(
    "Please wait...",
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'),
  ).animate().fade().obs;
  Rx<Animate> mainWeatherTypeLoadingText = Text(
    "fetching latest report",
    textAlign: TextAlign.center,
    style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'),
  ).animate().fade().obs;
  RxBool returnLoading = true.obs;

  DBHelper dbHelper = DBHelper();
  RxList cityListToDisplay = [].obs;

  Future<void> fetchWeather() async {
    returnLoading.value = true;
    sunriseTime.value = '...';
    sunsetTime.value = '...';
    minTemp.value = '...';
    maxTemp.value = '...';

    updateDateTimeGreeting();
    if (locality.isEmpty) {
      locality = await getLocalityName();
    }
    if (locality.isEmpty) {
      errorResponse();
      Fluttertoast.showToast(msg: 'Error occured. Pull down to Retry.');
      return;
    }
    locationText.value = '📍 $locality';

    if (locality.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?q=$locality&appid=1d8523c9bffc38af6380df3412ed1c3e"));
        if (response.statusCode == 200) {
          Weather data = Weather.fromJson(jsonDecode(response.body));
          updateValues(data);
        } else {
          print("Response Code --> ${response.statusCode}");
          errorResponse();
        }
      } catch (e) {
        print("Err --> $e");
        errorResponse(msg: "Failed to get latest weather. $e");
      }
    } else {
      errorResponse(msg: "Couldn't identify this location");
    }
  }

  Future<bool> isLocationPermissionGiven() async {
    LocationPermission permission = await Geolocator.checkPermission(); //denied
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: const Text("Location permission is denied. "
            "You can grant permission from Settings."),
        action: SnackBarAction(
          label: "Open",
          onPressed: () async {
            Fluttertoast.showToast(
                msg:
                    'Go to Permission >> Location >> "Allow while using the app."',
                toastLength: Toast.LENGTH_LONG);
            await Geolocator.openAppSettings();
          },
        ),
      ));
      return false;
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<List<double>> getLatLong() async {
    if (kIsWeb) {
      Position position = await Geolocator.getCurrentPosition();
      return [position.latitude, position.longitude];
    } else {
      if (await isLocationPermissionGiven()) {
        Position position = await Geolocator.getCurrentPosition();
        return [position.latitude, position.longitude];
      } else {
        return [];
      }
    }
  }

  Future<String> getLocalityName() async {
    List position = await getLatLong();
    if (position.isNotEmpty) {
      bool isInternetAvailable = await checkInternet();
      if (isInternetAvailable) {
        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(position[0], position[1]);
          if (placemarks[0].locality != null || placemarks[0].locality == "") {
            return placemarks[0].locality!;
          } else {
            return "";
          }
        } catch (e) {
          debugPrint("Error while getting Locality Name: $e");
          return "";
        }
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  Future<bool> checkInternet() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn) {
        return true;
      } else {
        Fluttertoast.showToast(msg: "Check your internet...");
        return false;
      }
    } catch (e) {
      debugPrint("Error while cheking for internet --> $e");
      return false;
    }
  }

  void errorResponse({String msg = ""}) {
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
    mainImage.value = 'assets/images/cloud_error.png';
    mainTemp.value = '--';
    mainWeatherType.value = '---';

    mainTempText.value = Text(
      mainTemp.value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'),
    ).animate().fade();
    mainWeatherTypeText.value = Text(
      mainWeatherType.value,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Color(0xffe5e5e5),
          fontSize: 28,
          fontWeight: FontWeight.w100,
          fontFamily: 'Poppins'),
    ).animate().fade();
    returnLoading.value = false;
    sunriseTime.value = '--';
    sunsetTime.value = '--';
    minTemp.value = '--';
    maxTemp.value = '--';
  }

  void updateValues(Weather data) {
    updateMainIcon(data.weather[0].id!);
    mainTemp.value =
        "${(data.main.temp - 273.15).toStringAsFixed(2).toString()} ° C";
    mainWeatherType.value = data.weather[0].main;
    mainTempText.value = Text(
      mainTemp.value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontSize: 64,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'),
    ).animate().fade();
    mainWeatherTypeText.value = Text(
      mainWeatherType.value,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Color(0xffe5e5e5),
          fontSize: 28,
          fontWeight: FontWeight.w100,
          fontFamily: 'Poppins'),
    ).animate().fade();
    returnLoading.value = false;
    sunriseTime.value = unixTimestampToTimeFormat(data.sys.sunrise);
    sunsetTime.value = unixTimestampToTimeFormat(data.sys.sunset);
    minTemp.value =
        "${(data.main.tempMin - 273.15).toStringAsFixed(2).toString()} ° C";
    maxTemp.value =
        "${(data.main.tempMax - 273.15).toStringAsFixed(2).toString()} ° C";
  }

  String unixTimestampToTimeFormat(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    return formattedTime;
  }

  void updateMainIcon(int id) {
    if (id == 800) {
      mainImage.value = 'assets/images/clear_sky.png';
    } else if (id == 801) {
      mainImage.value = 'assets/images/few_clouds.png';
    } else if (id > 801 && id < 805) {
      mainImage.value = 'assets/images/clouds.png';
    } else if (id >= 300 && id < 322) {
      mainImage.value = 'assets/images/drizzle.png';
    } else if (id == 511) {
      mainImage.value = 'assets/images/freezing_rain.png';
    } else if (id >= 500 && id <= 501) {
      mainImage.value = 'assets/images/light_rain.png';
    } else if (id >= 502 && id <= 531) {
      mainImage.value = 'assets/images/heavy_rain.png';
    } else if (id >= 600 && id <= 615) {
      mainImage.value = 'assets/images/snow.png';
    } else if (id >= 616 && id <= 622) {
      mainImage.value = 'assets/images/heavy_snow.png';
    } else if (id >= 200 && id <= 232) {
      mainImage.value = 'assets/images/thunder.png';
    } else if (id == 701) {
      mainImage.value = 'assets/images/mist.png';
    } else if (id == 711) {
      mainImage.value = 'assets/images/smoke.png';
    } else if (id == 721) {
      mainImage.value = 'assets/images/haze.png';
    } else if (id >= 731 && id <= 771) {
      mainImage.value = 'assets/images/normal weather.png';
    } else if (id == 781) {
      mainImage.value = 'assets/images/tornado.png';
    }
  }

  void updateDateTimeGreeting() {
    String date = DateFormat('EEE, d MMMM').format(DateTime.now());
    String time = DateFormat('h:mm a').format(DateTime.now());
    mainDate.value = date;
    mainTime.value = time;
    int hour = DateTime.now().hour;
    if (hour < 12) {
      greetText.value = "Good Morning";
    } else if (hour < 17) {
      greetText.value = "Good Afternoon";
    } else if(hour < 21) {
      greetText.value = "Good Evening";
    }
    else{
      greetText.value = "Good Night";
    }
  }

  Future<List<String>> fetchCityList() async {
    try {
      final response = await http.get(Uri.parse(
          "https://pkgstore.datahub.io/core/world-cities/world-cities_json/data/5b3dd46ad10990bca47b04b4739a02ba/world-cities_json.json"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> cityList = [];
        for (int i = 0; i < data.length; i++) {
          cityList.add(data[i]['name']);
        }
        cityList.sort();
        return cityList;
      } else {
        print("Fetch city response code error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error while fetching city list: $e");
      return [];
    }
  }

  Future<void> storeCitiesToDb() async {
    List<String> listFromApi = await fetchCityList();
    if (listFromApi.isNotEmpty) {
      try {
        await dbHelper.storeCitiesLocally(listFromApi);
      } catch (e) {
        debugPrint('Error while storing city list to database --> $e');
      }
    }
  }

  Future<void> getCityList() async {
    cityListToDisplay.clear();
    try {
      List<Map<String, dynamic>> list = await dbHelper.getAllCities();
      for (int i = 0; i < list.length; i++) {
        cityListToDisplay.add(list[i]['name']);
      }
    } catch (e) {
      print('error while storing data to db>>>>> $e');
    } finally {
      citySelectLoadingVisibility.value = false;
      citySelectContVisibility.value = true;
    }
  }
}
