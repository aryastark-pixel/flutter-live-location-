import 'dart:convert';
import 'package:http/http.dart' as http;
import'package:gps/models/location_model.dart';

Future<List<LocationModel>> getlist() async{
  var apiUrl = 'http://10.182.2.189:9000/locationapi/get/';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData.toString());
      return LocationModel.fromJsonList(jsonData);
    }
    else {
      throw Exception('Failed to fetch data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }


}

Future<int> postLocationData(Map<String, dynamic> dataToSend) async {
  var apiUrl = 'http://10.182.2.189:9000/locationapi/post/';
  try {
    print('here inside the post');
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(dataToSend), // Encode the data to JSON
      headers: {'Content-Type': 'application/json'}, // Set headers if needed
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData.toString());
      return  response.statusCode;
    }
    else {
      final jsonData = json.decode(response.body);
      print(jsonData.toString());
      return response.statusCode;

    }

  } catch (error) {
    throw Exception('Error: $error');
  }

}