import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weather_app/Routes/routes.dart';
import 'dart:io';

main() {

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff252525),
      systemNavigationBarColor: Color(0xff000000),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));

  HttpOverrides.global = MyHttpOverrides();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather App",
    initialRoute: '/',
    getPages: Routes.routes,
    unknownRoute: Routes.notFound,
  ));

}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}