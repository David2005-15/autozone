import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/utils/default_states.dart';
import 'package:autozone/utils/otp_verify_enum.dart';
import 'package:autozone/utils/registration_enum.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registration implements IRegistration {
  Dio dio = Dio();

  @override
  Future<DefaultState> verifyUser(String phoneNumber, String pin) async {
    var body = {"phoneNumber": "374$phoneNumber", "pin": pin};

    var result = await dio.post("https://autozone.onepay.am/api/v1/users/login",
        data: body, options: Options(
      validateStatus: (status) {
        return true;
      },
    ));

    if (result.data["success"] != null &&
        result.data["success"] as bool == true) {
      var prefs = await SharedPreferences.getInstance(); 

      prefs.setString("token", result.data["User"]["token"]);

      return DefaultState.success;
    }

    return DefaultState.error;
  }

  @override
  Future<RegistrationState> registerUser(String phoneNumber) async {
    var body = {"phoneNumber": "374$phoneNumber"};

    var response = await dio
        .post("https://autozone.onepay.am/api/v1/users/register", data: body);

    if (response.data["success"] as bool == true) {
      if (response.data["message"] == "Enter pin code.") {
        return RegistrationState.login;
      } else if (response.data["message"] ==
          "The verification code was sent successfully.") {
        return RegistrationState.regiter;
      }

      return RegistrationState.error;
    }

    throw Exception("Something went wrong");
  }

  @override
  Future<OtpVerifyEnum> verifyOtp(String phoneNumber, String otp) async {
    var body = {"phoneNumber": "374$phoneNumber", "verificationCode": otp};

    var response = await dio.post(
        "https://autozone.onepay.am/api/v1/users/verification",
        data: body, options: Options(
      validateStatus: (status) {
        return true;
      },
    ));

    if (response.data["success"] as bool == true) {
      var prefs = await SharedPreferences.getInstance();

      prefs.setString("token", response.data["token"]);

      return OtpVerifyEnum.verifiy;
    } else {
      return OtpVerifyEnum.error;
    }
  }
}
