import 'dart:convert';

class WeatherDataModel {
    Coord coord;
    List<Weather> weather;
    String base;
    Main main;
    int visibility;
    Wind wind;
    Clouds clouds;
    var dt;
    Sys sys;
    var id;
    String name;
    var cod;

    WeatherDataModel({this.coord,this.weather,this.base,this.main,this.visibility,this.wind,this.clouds,this.dt,this.sys,this.id,this.name,this.cod});

    factory WeatherDataModel.fromJson(Map<String, dynamic> json) {

      var list = json['weather'] as List;
      print(list.runtimeType); //returns List<dynamic>
      List<Weather> weatherList = list.map((i) => Weather.fromJson(i)).toList();

      return WeatherDataModel(
          coord: Coord.fromJson(json["coord"]),
          weather:weatherList,
          base: json["base"] as String,
          main: Main.fromJson(json["main"]),
          visibility: json["visibility"] as int,
          wind: Wind.fromJson(json["wind"]),
          clouds: Clouds.fromJson(json["clouds"]),
          dt: json["dt"] ,
          sys: Sys.fromJson(json["sys"]),
          id:  json["id"] ,
          name: json["name"] as String,
          cod:  json["cod"] ,
      ) ;
    }
}

class Coord {
  var lon;
  var lat;

  Coord({this.lon,this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json["lon"] ,
      lat: json["lat"] ,
    );
  }
}

class Weather {
  var id;
  String main;
  String description;
  String icon;

  Weather({this.id,this.main,this.description,this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json["id"] ,
      main: json["main"] as String,
      description: json["description"] as String,
      icon: json["icon"] as String,
    );
  }

}

class Main {
  var temp;
  var pressure;
  var humidity;
  var tempMin;
  var tempMax;
  var feelsLike;

  Main({this.temp,this.pressure,this.humidity,this.tempMin,this.tempMax,this.feelsLike});

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
        temp: json["temp"],
        pressure: json["pressure"],
        humidity: json["humidity"],
        tempMin: json["temp_min"] ,
        tempMax: json["temp_max"] ,
        feelsLike: json["feels_like"] ,
    );
  }

}

class Wind {
  var speed;
  var deg;

  Wind({this.speed,this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json["speed"] ,
      deg: json["deg"] ,
    );
  }
}

class Clouds {
  var all;

  Clouds({this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json["all"] ,
    );
  }
}

class Sys {
  var type;
  var id;
  var message;
  String country;
  var sunrise;
  var sunset;

  Sys({this.type,this.id,this.message,this.country,this.sunrise,this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      type: json["type"] ,
      id: json["id"] ,
      message: json["message"] ,
      country: json["country"] as String,
      sunrise: json["sunrise"] ,
      sunset: json["sunset"] ,
    );
  }
}

