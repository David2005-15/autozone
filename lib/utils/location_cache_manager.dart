import 'package:dio/dio.dart';

class LocationsCacheManager {
  static final LocationsCacheManager _singleton =
      LocationsCacheManager._internal();

  factory LocationsCacheManager() {
    return _singleton;
  }

  LocationsCacheManager._internal();

  var englishProvince = <String> [];
  var province = <String> [];
  List<dynamic> provinceData = [];

  void setProvince() async {
    province.clear();
    englishProvince.clear();

    Dio dio = Dio();

    var result = await dio.get(
      'https://autozone.onepay.am/api/v1/getLocations',
    );
    provinceData.clear();

    provinceData = result.data["locations"];
    province.add("Ընտրեք մարզը");

    for (int i = 0; i < provinceData.length; i++) {
      province.add(provinceData[i]["translations"]["hy"]["name"]);
      englishProvince.add(provinceData[i]["translations"]["en"]["name"]);
    }
  }

  List<String> getProvince() {
    return province;
  }

  List<dynamic> getProvinceData() {
    return provinceData;
  }

  List<String> getEnglishProvince() {
    return englishProvince;
  }
}
