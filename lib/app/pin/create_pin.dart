import 'package:autozone/app/otp_verification/forgot_pin.dart';
import 'package:autozone/app/pin/verify_pin.dart';
import 'package:autozone/core/widgets/keyboard/keyboard.dart';
import 'package:autozone/core/widgets/inputs/pin_input.dart';
import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

class CreatePin extends StatefulWidget {
  const CreatePin({Key? key}) : super(key: key);

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  int index = 0;

  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(height: MediaQuery.of(context).size.height * 0.4,),
              Align(
                  alignment: Alignment.center,
                  child: PinInput(
                    contollers: _controllers,
                    text: "Ստեղծել PIN գաղտնաբառ",
                    onCompleted: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const VerifyPin()));
                    },
                  )),
              Align(
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

                      if (index == 4) {
                        var pinRepo = ServiceProvider.required<IPinRepo>();

                        await pinRepo.savePinToStorage(_controllers
                            .map((controller) => controller.text)
                            .join());

                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const VerifyPin()));
                        });
                      }
                    },
                    isForgot: false,
                  ))
            ],
          )),
    );
  }
}
