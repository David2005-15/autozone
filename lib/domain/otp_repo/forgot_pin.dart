import 'package:autozone/domain/otp_repo/iforgot_pin.dart';
import 'package:autozone/utils/default_states.dart';
import 'package:dio/dio.dart';

class ForgotPin implements IForgotPin {
  Dio dio = Dio();

  @override
  Future<DefaultState> sendForgotPinOtp(String number) async {
    var body = {"phoneNumber": "374$number"};

    var result = await dio.post(
        "https://autozone.onepay.am/api/v1/users/sendSMSCodeForVerification",
        data: body, options: Options(validateStatus: (status) {
      return true;
    }));

    if (result.data["success"] as bool == true) {
      return DefaultState.success;
    }

    return DefaultState.error;
  }
}
