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

class AddNewCarPage extends StatefulWidget {
  final String? pin;

  const AddNewCarPage({Key? key, this.pin}) : super(key: key);

  @override
  State<AddNewCarPage> createState() => _AddNewCarPageState();
}

class _AddNewCarPageState extends State<AddNewCarPage> {
  final TextEditingController _carNumberController = TextEditingController();

  var autoService = ServiceProvider.required<IAuto>();
  var registrationService = ServiceProvider.required<IRegistration>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
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
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        title: const Text(
          'Մեքենայի ավելացում',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[buildSearchSection()],
        ),
      ),
    );
  }

  Container buildTitleSection() {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffF3F4F6)),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      child: const Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Մեքենայի նույնականացում",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Color(0xff164866),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildSearchSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          const Text(
            "Մուտքագրեք վկայագրի համարը",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xff164866),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SuffixInput(
              controller: _carNumberController,
              keyboardType: TextInputType.text,
              margin: const EdgeInsets.only(left: 70, right: 70, top: 10),
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
              padding: const EdgeInsets.only(right: 70, left: 70, top: 20),
              child: ButtonFactory.createButton(
                  "cta_green",
                  "Որոնել",
                  _carNumberController.text.length == 8
                      ? () async {
                          // _carNumberController.text = "";
                          loading(context);

                          String carNumber = _carNumberController.text;

                          _carNumberController.text = "";

                          var result = await autoService
                              .addAuto(carNumber.toUpperCase());

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
                                car_found(context, car, regNumber,
                                    carNumber, widget.pin);
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
                              car_is_not_available(
                                  context, carNumber);
                            } else {
                              Navigator.pop(context);
                              error(context, carNumber);
                            }
                          });
                        }
                      : null,
                  double.infinity,
                  42))
        ],
      ),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    // Check if the text is too long or doesn't meet the format.
    if (newText.length > 8) {
      // Text is too long, truncate it to 8 characters.
      return TextEditingValue(
        text: newText.substring(0, 8),
        selection: TextSelection.collapsed(offset: 8),
      );
    } else if (newText.isNotEmpty &&
        !RegExp(r'^[A-Za-z]{0,2}\d{0,6}$').hasMatch(newText)) {
      // Text doesn't meet the format, remove the invalid characters.
      return TextEditingValue(
        text: _removeInvalidCharacters(newText),
        selection: TextSelection.collapsed(
            offset: _removeInvalidCharacters(newText).length),
      );
    } else {
      // Text is valid, allow it as-is.
      return newValue;
    }
  }

  String _removeInvalidCharacters(String text) {
    // Remove invalid characters from the input.
    return text.replaceAll(RegExp(r'[^A-Za-z\d]'), '');
  }
}
