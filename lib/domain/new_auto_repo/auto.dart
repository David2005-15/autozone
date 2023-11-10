import 'dart:collection';

import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auto extends IAuto {
  Dio dio = Dio();

  @override
  Future<Map<String, dynamic>> addAuto(String auto) async {
    var preferences = await SharedPreferences.getInstance();

    var phoneNumber = preferences.getString('phone') ?? '';

    var body = {"techNumber": auto, "phoneNumber": "374$phoneNumber"};

    var result = await dio.post("https://autozone.onepay.am/api/v1/cars/search",
        data: body, options: Options(validateStatus: (status) {
      return true;
    }));

    if (result.data["success"] != null &&
        result.data["success"] as bool == true) {

      preferences.setString("mark", result.data["carData"]["car"].toString().split(' ')[0]);
      preferences.setString("reg_number", result.data["carData"]["car_reg_no"]);


      return result.data["carData"];
    }

    return result.data;
  }

  @override
  Future<Map<String, dynamic>> applyAddedAuto(String auto) async {
    var preferences = await SharedPreferences.getInstance();

    var phoneNumber = preferences.getString('phone') ?? '';

    var body = {"techNumber": auto, "phoneNumber": "374$phoneNumber"};

    var result = await dio.post("https://autozone.onepay.am/api/v1/cars/addCar",
        data: body, options: Options(validateStatus: (status) {
      return true;
    }));

    if (result.data["success"] != null &&
        result.data["success"] as bool == true) {

      return result.data;
    }

    return HashMap();
  } 

  @override
  bool isValidAuto(String auto) {
    throw UnimplementedError();
  }
}
