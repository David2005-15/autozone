import 'package:autozone/utils/default_states.dart';

abstract class IForgotPin {
  Future<DefaultState> sendForgotPinOtp(String number);
}
