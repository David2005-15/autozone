import 'package:autozone/app/home/home_page.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/widgets/inputs/input_box_without_suffix.dart';
import 'package:autozone/domain/pin_repo/ipin_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

class NewPinPage extends StatefulWidget {
  const NewPinPage({Key? key}) : super(key: key);

  @override
  State<NewPinPage> createState() => _NewPinPage();
}

class _NewPinPage extends State<NewPinPage> {
  var newPin = TextEditingController();
  var pinAgain = TextEditingController();

  var pinService = ServiceProvider.required<IPinRepo>();

  bool isWrongPin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Ստեղծել նոր PIN գաղտնաբառ",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
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
              keyboardType: TextInputType.number,
              label: "Նոր PIN գաղտնաբառ",
              controller: newPin,
              onChanged: (p0) {
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              margin: const EdgeInsets.all(15),
            ),
            InputBoxWithoutSuffix(
              keyboardType: TextInputType.number,
              label: "Կրկնել PIN գաղտնաբառը",
              controller: pinAgain,
              onChanged: (p0) {
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              margin: const EdgeInsets.all(15),
            ),
            ButtonFactory.createButton(
                "cta",
                "Հաստատել",
                newPin.text == pinAgain.text &&
                        newPin.text.isNotEmpty &&
                        pinAgain.text.isNotEmpty &&
                        pinAgain.text.length == 4 &&
                        newPin.text.length == 4
                    ? () async {
                        var result = await pinService.savePin(newPin.text);

                        if (result == true) {
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage(
                                          isRedirect: false,
                                        )));
                          });
                        }
                      }
                    : null,
                double.infinity,
                42,
                margin: const EdgeInsets.all(15))
          ],
        ),
      ),
    );
  }
}
