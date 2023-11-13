import 'dart:async';

import 'package:autozone/app/otp_verification/sms_limit_page.dart';
import 'package:autozone/app/pin/new_pin.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/inputs/input_box_without_suffix.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/utils/otp_verify_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPinOtpPage extends StatefulWidget {
  const ForgotPinOtpPage({Key? key}) : super(key: key);

  @override
  State<ForgotPinOtpPage> createState() => _ForgotPinOtpPage();
}

class _ForgotPinOtpPage extends State<ForgotPinOtpPage> {
  late Timer _timer;
  int _remainingSeconds = 1 * 60;
  int restartCount = 1;

  var pinController = TextEditingController();
  var verifyOtpService = ServiceProvider.required<IRegistration>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        timer.cancel();
        _timer.cancel();
      }
    });
  }

  bool isWrongPin = false;

  @override
  Widget build(BuildContext context) {
    double seconds = _remainingSeconds % 60;
    double minutes = _remainingSeconds / 60;

    String secondsString = seconds.toInt().toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        title: const Text(
          "Նույնականացման կոդի ստացում",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 2),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Image(
              image: AssetImage("assets/Settings/BackIcon.png"),
              width: 21,
              height: 21,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            InputBoxWithoutSuffix(
              label: "Նույնականացման կոդ",
              controller: pinController,
              margin: const EdgeInsets.all(20),
              onChanged: (val) {
                setState(() {});
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Visibility(
                visible: isWrongPin,
                child: const Text(
                  "Հաստատման ծածկագիրը սխալ է",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.red),
                ),
              ),
            ),
            minutes == 0 && seconds == 0
                ? ButtonFactory.createButton('onprim', "Ուղարկել կրկին", () {
                    if (restartCount == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SMSLimitPage()));
                    }
                    setState(() {
                      _remainingSeconds = 1 * 60;
                      _timer = Timer.periodic(
                          const Duration(seconds: 1), _updateTimer);
                      restartCount++;
                    });
                  }, MediaQuery.of(context).size.width - 100, 42)
                : buildCountdownTimerOfSms(minutes, secondsString),
            Visibility(
              visible: pinController.text.length == 4,
              child: ButtonFactory.createButton("cta", "Հաստատել", () async {
                var prefs = await SharedPreferences.getInstance();

                var phoneNumber = prefs.getString("phone") ?? "";

                var result = await verifyOtpService.verifyOtp(
                    phoneNumber, pinController.text);

                if (result != OtpVerifyEnum.verifiy) {
                  setState(() {
                    isWrongPin = true;
                  });

                  return;
                }

                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewPinPage()));
                });
              }, double.infinity, 42, margin: const EdgeInsets.all(20)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCountdownTimerOfSms(double minutes, String secondsString) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text("Ստացման ժամանակ՝ ${minutes.toInt()}:$secondsString",
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866))),
    );
  }
}
