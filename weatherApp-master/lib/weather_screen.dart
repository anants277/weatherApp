import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'location.dart';
import 'networking.dart';
import 'data_models.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:weather_icons/weather_icons.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  List<String> languages = ['English', 'Hindi', 'Russian', 'French','Italian'];
  String backGroundImage =  constants.getWeatherImageString(320);
  String temperature = '-';
  String city = '-';
  String weatherType = '-';
  String weatherDescription = '-';

  String tempMaxMin = '-';
  String pressure = '-';
  String humidity = '-';
  String windSpeed = '-';
  String visibility = '-';
  String sunrise = "-";
  String sunset = "-";

  bool showLoading = false;
  bool showError = false;
  bool showTextField = false;
  var cityToSearch = 'Dewas';
  var receivedCityName = 'Dewas';
  var correctCity = 'Dewas';

  constants.LanguageCode currentLanguageCode = constants.LanguageCode.en;
  String currentLanguage = 'English';

  Location location = Location();
  NetworkManager networkManager = NetworkManager();

  @override
  void initState() {
    super.initState();
    getWeatherData(searchType: constants.SearchType.city,languageCode: currentLanguageCode);
  }

  void updateUI({WeatherDataModel weatherDataModel, constants.SearchType searchType}) {
      setState(() {
        print('In Update UI');
        backGroundImage = constants.getWeatherImageString(weatherDataModel.weather.first.id);
        temperature = weatherDataModel.main.temp.toInt().toString();
        city = cityToSearch;
        if(searchType == constants.SearchType.currentLocation) {
          correctCity = weatherDataModel.name;
        } else {
          correctCity = cityToSearch;
        }
        print(city);
        weatherType = weatherDataModel.weather.first.main;
        showLoading = false;
        showError = false;
        tempMaxMin ='${weatherDataModel.main.tempMax.toInt()}/${weatherDataModel.main.tempMin.toInt()}';
        pressure = weatherDataModel.main.pressure.toString();
        humidity = weatherDataModel.main.humidity.toString();
        windSpeed = weatherDataModel.wind.speed.toString();
        visibility = weatherDataModel.visibility != null ? weatherDataModel.visibility.toString() : '- ';
        weatherDescription = weatherDataModel.weather.first.description;
        receivedCityName = weatherDataModel.name;
//        sunrise = new DateTime.fromMicrosecondsSinceEpoch(weatherDataModel.sys.sunrise).toString();
//        sunset = new DateTime.fromMicrosecondsSinceEpoch(weatherDataModel.sys.sunset).toString();

      });
  }

  void cityEntered({String enteredText}) {

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(cityToSearch != null && cityToSearch != '' && cityToSearch != correctCity) {
      print('will search $cityToSearch');
      getWeatherData(searchType: constants.SearchType.city,languageCode: currentLanguageCode);
    } else {
      print('no search');
      setState(() {
        showTextField = false;
      });
    }


  }

  Future<void> refreshWeather() async{
    getWeatherData(searchType: constants.SearchType.currentLocation,languageCode: currentLanguageCode);
    return null;
  }

  void getWeatherData({@required constants.SearchType searchType, @required constants.LanguageCode languageCode}) async{
      var weatherData;
      setState(() {
        showLoading = true;
        showTextField = false;
      });
      if(searchType == constants.SearchType.currentLocation) {
        setState(() {
          currentLanguage = 'English';
        });
        await location.getCurrentPosition();
        print(location.longitude);
        print(location.latitude);
        weatherData = await networkManager.getData(constants.getUrlForCurrentLocation(location.latitude, location.longitude,languageCode.toShortString()));
      }
      else if(searchType == constants.SearchType.city) {
        weatherData = await networkManager.getData(constants.getUrlForCity(cityToSearch,languageCode.toShortString()));
      }
      else if(searchType == constants.SearchType.cityWithLanguage) {
        weatherData = await networkManager.getData(constants.getUrlForCity(correctCity,languageCode.toShortString()));
      }

      print(weatherData);
      if(weatherData != null) {
        WeatherDataModel weatherDataModel = WeatherDataModel.fromJson(weatherData);
        updateUI(weatherDataModel: weatherDataModel,searchType: searchType);
      } else {
        print('something went wrong');
        setState(() {
          showLoading = false;
          showError = true;
        });
      }
    }
  @override
  Widget build(BuildContext context) {

    Widget loadingIndicator =showLoading ? Container(
      child: Column(
        children: <Widget>[
          spinkit.SpinKitHourGlass(
            color: Colors.white,
          ),
          Text(
              'loading...',
            style: constants.infoTextStyle,
          )
        ],
      ),
    ): SizedBox();


    Widget infoContainer(String property, String value, IconData icon) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: Colors.white,
            ),
            Container(
              child: Text(
                property,
                textDirection: TextDirection.ltr,
                style: constants.infoTextStyle,
              ),
            ),
            Text(
              value,
              style: constants.infoTextStyle,
            )
          ],
        ),
      );
     }

      Widget allInfoContainer({String tempMaxMin,String pressure, String humidity, String windSpeed, String visibility}) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey.withAlpha(80),
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: <Widget>[
                infoContainer('Feels like', tempMaxMin+'°C',WeatherIcons.celsius),
                infoContainer('Temp Max/Min', tempMaxMin+'°C',WeatherIcons.thermometer),
                infoContainer('Atm. Pressure', pressure+'hPa', WeatherIcons.barometer),
                infoContainer('Humidity', humidity+'%', WeatherIcons.humidity),
                infoContainer('Wind Speed', windSpeed+'mph', WeatherIcons.wind),
                infoContainer('Visibility', visibility+'m', Icons.remove_red_eye),
                infoContainer('Sunrise', sunrise, WeatherIcons.sunrise),
                infoContainer('Sunset', sunset, WeatherIcons.sunset),
              ],
            ),
          ),
        );
      }

      Widget textWidget = Container(
        height: 30,
        width: 150,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                cursorColor: constants.primaryColor,
                autofocus: true,
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: constants.textFieldInputDecoration(onPressed: () {
                  cityEntered(enteredText: cityToSearch);
                }),
                onChanged: (value) {
                  cityToSearch = value;
                },
                onSubmitted: (value) {
                  cityEntered(enteredText: cityToSearch);
                },
                onTap: () {
                  print('tapped');
//                  cityToSearch = '';
                },
              ),
            ),
          ],
        ),
      ) ;

      Widget cityLabelWidget = Row(
        children: <Widget>[
          Text(
            correctCity,
            style: constants.appbarTextStyle,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                showTextField = true;
              });
            },
            icon: Icon(
              Icons.edit,
              color: Colors.grey.shade100,
              size: 25,
            ),
          )
        ],
      );

      Widget errorText = showError ? Text(
        'Something went wrong!!!',
        style: constants.errorTextStyle,
      ) : SizedBox();

      Widget cityTextWidget = showTextField ? textWidget : cityLabelWidget;

      return SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backGroundImage),
                fit: BoxFit.cover,
              ),
            ) ,
            child: RefreshIndicator(
              onRefresh: () async{
                refreshWeather();
              },
              child: ListView(
//            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(

                        onPressed: () {
                          getWeatherData(searchType: constants.SearchType.currentLocation,languageCode: currentLanguageCode);
                        },
                        icon: Icon(
                          Icons.near_me,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      cityTextWidget,

                      DropdownButton<String>(
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        hint: Text(
                            currentLanguage,
                          style: constants.infoTextStyle,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30,
                        ),
                        onChanged: (String newValue) {
                          print(newValue);
                          switch(newValue) {
                            case 'English' :
                              currentLanguageCode = constants.LanguageCode.en;
                              setState(() {
                                currentLanguage = 'English';
                              });
                              break;
                            case 'Hindi' :
                              currentLanguageCode = constants.LanguageCode.hi;
                              setState(() {
                                currentLanguage = 'Hindi';
                              });
                              break;
                            case 'Russian' :
                              currentLanguageCode = constants.LanguageCode.ru;
                              setState(() {
                                currentLanguage = 'Russian';
                              });
                              break;
                            case 'French' :
                              currentLanguageCode = constants.LanguageCode.fr;
                              setState(() {
                                currentLanguage = 'French';
                              });
                              break;
                            default :
                              currentLanguageCode = constants.LanguageCode.it;
                              setState(() {
                                currentLanguage = 'Italian';
                              });
                          }
                          print(currentLanguageCode.toShortString());
                          getWeatherData(searchType: constants.SearchType.cityWithLanguage, languageCode: currentLanguageCode);
                        },
                        items: languages.map((String dropDownStringItems) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItems,
                            child: Text(dropDownStringItems),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        temperature,
                        style: constants.tempTextStyle,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 18),
                        child: Text(
                          '°C',
                          style: constants.buttonTextStyle,
                        ),
                      )
                    ],
                  ),
                  Text(
                    weatherType,
                    style: constants.infoTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$weatherDescription',
                    style: constants.infoTextStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$receivedCityName',
                    style: constants.infoTextStyle,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  loadingIndicator,
                  Center(child: errorText),
                  allInfoContainer(tempMaxMin: tempMaxMin,pressure: pressure,humidity: humidity,windSpeed: windSpeed,visibility: visibility),

                ],
              ),
            ),
          ),
        ),
      );
    }
  }
