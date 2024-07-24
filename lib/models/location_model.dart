class LocationModel{
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  LocationModel(
      {
        required this.latitude,
        required this.longitude,
        required this.dateTime,

    });


  factory LocationModel.fromJson(Map<String,dynamic> json){
    return LocationModel(
        latitude:json['latitude'] as double,
        longitude:json['longitude'] as double,
        dateTime: json['dateTime'] as DateTime,
    );

  }

  static List<LocationModel> fromJsonList(List<dynamic> jsonList){
    return jsonList.map((json)=> LocationModel.fromJson(json)).toList();
  }
}