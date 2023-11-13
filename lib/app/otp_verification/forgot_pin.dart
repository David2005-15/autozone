import 'package:autozone/app/otp_verification/forgot_pin_otp.dart';
import 'package:autozone/app/otp_verification/sms_limit_page.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/domain/otp_repo/iforgot_pin.dart';
import 'package:autozone/utils/default_states.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPinPage extends StatefulWidget {
  const ForgotPinPage({Key? key}) : super(key: key);

  @override
  State<ForgotPinPage> createState() => _ForgotPinPageState();
}

class _ForgotPinPageState extends State<ForgotPinPage> {
  var forgotPinService = ServiceProvider.required<IForgotPin>();

  void getPhoneNumberFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = "${prefs.getString('phone')}";
    });
  }

  String phoneNumber = '';

  @override
  void initState() {
    getPhoneNumberFromStorage();

    super.initState();
  }

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
          title: const Text(
            "Վերականգնել PIN գաղտնաբառը",
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
          child: Stack(
            children: <Widget>[
              buildPhoneNumberSection(),
            ],
          ),
        ));
  }

  Widget buildPhoneNumberSection() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // height: MediaQuery.of(context).size.height * 0.2,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF2F2F4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 21),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: const Text(
                    "Նույնականացման կոդը ուղարկվելու է \n Ձեր բջջային համարին։",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xff164866)),
                  ),
                ),
                const SizedBox(height: 21),
                Text(
                  "0$phoneNumber",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xff164866)),
                ),
                const SizedBox(height: 17),
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: ButtonFactory.createButton("cta", "Ուղարկել", () async {
                var result =
                    await forgotPinService.sendForgotPinOtp(phoneNumber);

                if (result == DefaultState.success) {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPinOtpPage()));
                  });
                } else {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SMSLimitPage()));
                  });
                }
              }, double.infinity, 42,
                  margin: const EdgeInsets.symmetric(horizontal: 20)))
        ],
      ),
    );
  }
}
