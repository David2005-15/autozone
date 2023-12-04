// ignore_for_file: use_build_context_synchronously

import 'package:autozone/app/no_internet.dart';
import 'package:autozone/app/otp_verification/otp_verification.dart';
import 'package:autozone/app/pin/pin_authorization.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/inputs/input_box.dart';
import 'package:autozone/domain/default/text_style.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/utils/registration_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _phoneNumberController = TextEditingController();

  bool isButtonEnabled = false;
  bool hasInternet = true;
  var registrationService = ServiceProvider.required<IRegistration>();

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
  }

  Future<void> checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        setState(() {
          hasInternet = true;
        });
      } else {
        setState(() {
          hasInternet = false;
        });
      }
    } catch (e) {
      setState(() {
        hasInternet = false;
      });
    }

    print(hasInternet);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return hasInternet
        ? Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Background.png"),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: <Widget>[buildAppLogo(), buildAppLoginSection()],
                )))
        : const NoInternetPage(
            isRegistered: false,
          );
  }

  Align buildAppLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: const Image(image: AssetImage("assets/Settings/Logo2.png"), width: 171, height: 40,)),
    );
  }

  Align buildAppLoginSection() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "ՄՈՒՏՔ | ԳՐԱՆՑՈՒՄ",
                style: defaultStyle(22),
              ),
            ),
            InputBox(
              label: "XXXXXXXX",
              controller: _phoneNumberController,
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              keyboardType: TextInputType.phone,
              onChanged: (val) {
                if (val.length == 8) {
                  setState(() {
                    isButtonEnabled = true;
                  });
                } else {
                  setState(() {
                    isButtonEnabled = false;
                  });
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^(?!0).*')),
                LengthLimitingTextInputFormatter(8)
              ],
            ),
            ButtonFactory.createButton(
                "cta",
                "Առաջ",
                isButtonEnabled
                    ? () async {
                        var prefs = await SharedPreferences.getInstance();
                        print(prefs.getKeys());

                        RegistrationState registrationState =
                            await registrationService
                                .registerUser(_phoneNumberController.text);

                        if (registrationState == RegistrationState.regiter) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtpVerification(
                                        number: _phoneNumberController.text,
                                      )));
                        } else if (registrationState ==
                            RegistrationState.login) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PinAuthorization()));
                        }

                        keepPhoneNumberIsStorage(_phoneNumberController.text);
                      }
                    : null,
                double.infinity,
                42,
                margin: const EdgeInsets.only(left: 30, right: 30, top: 20))
          ],
        ),
      ),
    );
  }

  Future keepPhoneNumberIsStorage(String phoneNumber) async {
    var preferences = await SharedPreferences.getInstance();

    preferences.setString("phone", phoneNumber);
  }
}
