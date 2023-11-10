import 'dart:async';

import 'package:autozone/app/otp_verification/sms_limit_page.dart';
import 'package:autozone/app/pin/create_pin.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/inputs/otp_input.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/utils/otp_verify_enum.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

class OtpVerification extends StatefulWidget {
  final String number;

  const OtpVerification({required this.number, super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());

  late Timer _timer;
  int _remainingSeconds = 1 * 60;
  bool foundOtpMatch = false;

  var registrationService = ServiceProvider.required<IRegistration>();

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

  int restartCount = 1;
  bool isWrongPin = false;

  @override
  Widget build(BuildContext context) {
    double seconds = _remainingSeconds % 60;
    double minutes = _remainingSeconds / 60;

    String secondsString = seconds.toInt().toString().padLeft(2, '0');

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Հաստատման ծածկագրի ստացում",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xff164866)),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20), child: buildNumberRow()),
          Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpVerificationInput(
                    contollers: _otpControllers,
                    onCompleted: () async {
                      await _navigateToPinAuthorization();
                    },
                  ),
                  Visibility(
                    visible: isWrongPin,
                    child: const Text(
                      "Հաստատման ծածկագիրը սխալ է",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.red),
                    ),
                  )
                ],
              )),
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
              : buildCountdownTimerOfSms(minutes, secondsString)
        ],
      ),
    ));
  }

  Row buildNumberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Image(
            image: AssetImage("assets/Sms.png"),
            width: 24,
            height: 24,
          ),
        ),
        Text(
          "0${widget.number}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xff164866)),
        ),
      ],
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

  Future _navigateToPinAuthorization() async {
    late OtpVerifyEnum result;

    if (_otpControllers.every((element) => element.text.isNotEmpty)) {
      result = await registrationService.verifyOtp(
          widget.number, _otpControllers.map((e) => e.text).join());
    }

    if (result == OtpVerifyEnum.verifiy) {
      Future.delayed(Duration.zero, () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreatePin()));
      });
    } else {
      setState(() {
        isWrongPin = true;
      });
    }
  }
}
