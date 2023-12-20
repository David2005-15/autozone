import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/core/widgets/keyboard/keyboard.dart';
import 'package:autozone/core/widgets/inputs/pin_input.dart';
import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPin extends StatefulWidget {
  const VerifyPin({Key? key}) : super(key: key);

  @override
  State<VerifyPin> createState() => _VerifyPin();
}

class _VerifyPin extends State<VerifyPin> {
  int index = 0;

  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  var registrationService = ServiceProvider.required<IRegistration>();

  bool isWrongPin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xff164866)),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Container(height: MediaQuery.of(context).size.height * 0.4,),
              Container(),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: PinInput(
                            contollers: _controllers,
                            text: "Կրկնել PIN գաղտնաբառը",
                            onCompleted: () {},
                          )),
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
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomKeyboard(
                        onKeyPressed: (v) async {
                          if (v == 'backspace') {
                            if (index == 0) return;
                            index--;
                            _controllers[index].text = '';
                          } else {
                            if (index > 3) return;
                            _controllers[index].text = v;
                            index++;
                          }

                          var prefs = await SharedPreferences.getInstance();

                          if (index == 4) {
                            var pinRepo = ServiceProvider.required<IPinRepo>();

                            bool isValidPin = await pinRepo.verifySavedPin(
                                _controllers
                                    .map((e) => e.text)
                                    .toList()
                                    .join(''));

                            if (isValidPin) {
                              bool success = await pinRepo.savePin(_controllers
                                  .map((e) => e.text)
                                  .toList()
                                  .join(''));

                              if (success) {
                                await registrationService.verifyUser(prefs.getString("phone") ?? "",
                                    _controllers.map((e) => e.text).join(''));

                                Future.delayed(Duration.zero, () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => const HomePage(
                                                isRedirect: false,
                                              )));
                                });
                              }
                            } else {
                              setState(() {
                                isWrongPin = true;
                              });
                            }
                          }
                        },
                        isForgot: false,
                      )),
                ],
              )
            ],
          )),
    );
  }
}
