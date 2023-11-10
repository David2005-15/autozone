import 'package:autozone/utils/default_states.dart';
import 'package:autozone/utils/otp_verify_enum.dart';
import 'package:autozone/utils/registration_enum.dart';

abstract class IRegistration {
  Future<RegistrationState> registerUser(String phoneNumber);
  Future<OtpVerifyEnum> verifyOtp(String phoneNumber, String otp);
  Future<DefaultState> verifyUser(String phoneNumber, String pin);
}