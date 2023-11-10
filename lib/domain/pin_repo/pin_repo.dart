import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinRepo implements IPinRepo {
  Dio dio = Dio();

  @override
  bool isValidPin(String pin) {
    throw UnimplementedError();
  }

  @override
  Future savePinToStorage(String pin) async {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString("pin", pin);
  }

  @override
  Future<bool> savePin(String pin) async {
    var preferences = await SharedPreferences.getInstance();

    String token = preferences.getString("token") ?? '';

    var body = {"pin": pin};

    var response = await dio.patch(
        "https://autozone.onepay.am/api/v1/users/createOrUpdatePin",
        data: body,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ));

    if (response.data["success"] as bool == true) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Future<bool> verifySavedPin(String pin) async {
    var preferences = await SharedPreferences.getInstance();

    return preferences.getString('pin') == pin;
  }
}
