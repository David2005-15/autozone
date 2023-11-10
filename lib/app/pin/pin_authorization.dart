import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/app/otp_verification/forgot_pin.dart';
import 'package:autozone/core/widgets/keyboard/keyboard.dart';
import 'package:autozone/core/widgets/inputs/pin_input.dart';
import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:autozone/utils/default_states.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinAuthorization extends StatefulWidget {
  const PinAuthorization({Key? key}) : super(key: key);

  @override
  State<PinAuthorization> createState() => _PinAuthorizationState();
}

class _PinAuthorizationState extends State<PinAuthorization> {
  int index = 0;
  List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  late String phoneNumber;

  IRegistration registrationService = ServiceProvider.required<IRegistration>();
  IPinRepo pinService = ServiceProvider.required<IPinRepo>();

  void getPhoneNumberFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = "${prefs.getString('phone')}";
    });
  }

  @override
  void initState() {
    getPhoneNumberFromStorage();
    super.initState();
  }

  bool isWrongPin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Container(height: MediaQuery.of(context).size.height * 0.4,), buildCustomPinInput(), buildCustomKeyboard()],
          )),
    );
  }

  Widget buildCustomKeyboard() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: CustomKeyboard(
          onKeyPressed: (v) async {
            if (v == 'backspace') {
              if (index == 0) return;
              index--;
              _controllers[index].text = '';
            } else if (v == 'forgot') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPinPage()));
            } else {
              if (index > 3) return;
              _controllers[index].text = v;
              index++;
            }

            if (_controllers.every((element) => element.text.isNotEmpty)) {
              var result = await registrationService.verifyUser(
                  phoneNumber, _controllers.map((e) => e.text).join(''));

              pinService
                  .savePinToStorage(_controllers.map((e) => e.text).join(''));

              if (result == DefaultState.success) {
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage(
                                isRedirect: false,
                              )));
                });
              } else {
                setState(() {
                  isWrongPin = true;
                  index = 0;

                  _controllers = [
                    TextEditingController(),
                    TextEditingController(),
                    TextEditingController(),
                    TextEditingController()
                  ];
                });
              }
            }
          },
          isForgot: true,
        ));
  }

  Widget buildCustomPinInput() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinInput(
              contollers: _controllers,
              text: "Մուտքագրեք PIN գաղտնաբառը",
              onCompleted: () async {
                var result = await registrationService.verifyUser(
                    phoneNumber, _controllers.map((e) => e.text).join(''));

                if (result == DefaultState.success) {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage(
                                  isRedirect: false,
                                )));
                  });
                }
              },
            ),
            Visibility(
              visible: isWrongPin,
              child: const Text(
                "PIN գաղտնաբառը սխալ է",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.red),
              ),
            )
          ],
        ));
  }
}
