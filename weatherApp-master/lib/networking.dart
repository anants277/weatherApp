import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkManager {
  Future getData(String url) async{
    http.Response response = await http.get(url);
    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      return null;
    }
  }
}