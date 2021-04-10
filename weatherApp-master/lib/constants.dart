import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1D1E33);
const Color secondryColor = Color(0xFF111328);
const String openWeatherApiKey = 'd26bc40c4f341dded4e71fe695abe538';

const String urlPrefix = 'api.openweathermap.org/data/2.5/weather?';

String getUrlForCurrentLocation(double lat, double lon, String langCode) {
  //TODO : Check for possible solutions for language
  return 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=metric&lang=en';
}
String getUrlForCity(String city, String langCode) {
  print('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$openWeatherApiKey&units=metric&lang=$langCode');
  return 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$openWeatherApiKey&units=metric&lang=$langCode';
}

class Constants{
  static const String Subscribe = 'Subscribe';
  static const String Settings = 'Settings';
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[
    Subscribe,
    Settings,
    SignOut
  ];
}

const appbarTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 25,
  fontFamily: 'Spartan MB',
  color: Colors.white,
);

const buttonTextStyle = TextStyle(
  fontSize: 30,
  fontFamily: 'Spartan MB',
  color: Colors.white,
);

const errorTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Spartan MB',
  color: Colors.red,
);

const tempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
  color: Colors.white,
);

const infoTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
  color: Colors.white,
);

InputDecoration textFieldInputDecoration({Function onPressed}) {
  return InputDecoration(
      contentPadding: EdgeInsets.only(top: 5,left: 5),
      filled: true,
      fillColor: Colors.white,
      hintText: 'Enter City',
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        padding: EdgeInsets.only(bottom: 2),
        onPressed: () {
          onPressed();
        },
        icon: Icon(
          Icons.done,
          color: primaryColor,
        ),
      )
  );
}


String getWeatherImageString(int condition) {
  if (condition < 300) {
    return 'images/thunderstorm.jpg';
  } else if (condition < 400) {
    return 'images/drizzle.jpg';
  } else if (condition < 600) {
    return 'images/rainfall.jpg';
  } else if (condition < 700) {
    return 'images/snowfall.jpg';
  } else if (condition < 800) {
    return 'images/haze.jpg';
  } else if (condition == 800) {
    return 'images/clearsky.jpg';
  } else if (condition <= 804) {
    return 'images/clouds.jpg';
  } else {
    return 'images/sunny.jpg‍';
  }
}

enum SearchType {
  currentLocation,
  city,
  cityWithLanguage
}

enum LanguageCode {
  en,
  hi,
  ru,
  fr,
  it
}

extension ParseToString on LanguageCode {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
