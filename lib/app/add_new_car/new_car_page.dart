import 'package:autozone/core/alert_dialogs/car_found.dart';
import 'package:autozone/core/alert_dialogs/car_is_not_available.dart';
import 'package:autozone/core/alert_dialogs/choose_tm_type.dart';
import 'package:autozone/core/alert_dialogs/document_hint.dart';
import 'package:autozone/core/alert_dialogs/error_alert.dart';
import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/inputs/sufix_input.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/domain/registration/iregistration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCarPage extends StatefulWidget {
  final String? pin;

  const NewCarPage({this.pin, super.key});

  @override
  State<NewCarPage> createState() => _NewCarPageState();
}

class _NewCarPageState extends State<NewCarPage> {
  final TextEditingController _carNumberController = TextEditingController();

  var autoService = ServiceProvider.required<IAuto>();
  var registrationService = ServiceProvider.required<IRegistration>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[buildTitleSection(), buildSearchSection()],
      ),
    );
  }

  Container buildTitleSection() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffF3F4F6)
          // color: Colors.yellow
          ),
      alignment: Alignment.center,
      child: const Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Image(
            image: AssetImage("assets/Settings/AddAuto.png"),
            width: 116,
            height: 95,
          ),
          SizedBox(
            height: 21,
          ),
          Text(
            "Մեքենայի նույնականացում",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Color(0xff164866),
            ),
          ),
          SizedBox(
            height: 29,
          )
        ],
      ),
    );
  }

  Container buildSearchSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          const Text(
            "Մուտքագրեք վկայագրի համարը",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          SuffixInput(
              controller: _carNumberController,
              keyboardType: TextInputType.text,
              margin: const EdgeInsets.only(left: 68, right: 68),
              onChanged: (p0) {
                setState(() {
                  _carNumberController.text =
                      _carNumberController.text.toUpperCase();
                });
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.allow(
                    RegExp(r'^[a-zA-Z]{0,2}\d{0,6}$')),
              ],
              label: "XX000000",
              onSuffixIcon: () {
                document_hint(context);
              }),
          Padding(
              padding: const EdgeInsets.only(top: 29),
              child: ButtonFactory.createButton(
                "cta_green",
                "Որոնել",
                _carNumberController.text.length == 8
                    ? () async {
                        loading(context);

                        String carNumber = _carNumberController.text;

                        _carNumberController.text = "";

                        var result =
                            await autoService.addAuto(carNumber.toUpperCase());

                        var prefs = await SharedPreferences.getInstance();

                        var car = prefs.getString("mark");
                        var regNumber = prefs.getString("reg_number");

                        Future.delayed(Duration.zero, () {
                          if (result["error"] != null &&
                              result["error"] !=
                                  "Another user already aded the car.") {
                            Navigator.pop(context);
                            error(context, carNumber);
                          } else if (result.isNotEmpty &&
                              result["success"] == null) {
                            Navigator.pop(context);

                            if (result["vehicle_types"].length == 1) {
                              car_found(context, car, regNumber, carNumber,
                                  widget.pin);
                            } else {
                              tm_type_car(
                                  context,
                                  car,
                                  regNumber,
                                  result["vehicle_types"],
                                  carNumber,
                                  widget.pin);
                            }
                          } else if (result["message"] ==
                              "Another user already aded the car."
                                  "Another user already aded the car.") {
                            Navigator.pop(context);
                            car_is_not_available(context, carNumber);
                          } else {
                            Navigator.pop(context);
                            error(context, carNumber);
                          }
                        });
                      }
                    : null,
                double.infinity,
                42,
                margin: const EdgeInsets.only(left: 68, right: 68),
              ))
        ],
      ),
    );
  }
}
