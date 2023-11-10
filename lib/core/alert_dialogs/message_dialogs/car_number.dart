import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:flutter/material.dart';

void carNumber(BuildContext context, String carNumber, VoidCallback sendApi) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  alignment: Alignment.center,
                   decoration: BoxDecoration(
                    color: const Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$carNumber մեքենայի վարորդ, գտել եմ Ձեր մեքենայի համարանիշը։",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Image(
                  image: AssetImage("assets/Message/9.png"),
                  height: 80,
                  width: 140,
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonFactory.createButton("cta_green", "Ուղարկել", () {
                  Navigator.pop(context);
                  sendApi();
                  success(context, "Հաղորդագրությունն ուղարկված է");
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5)),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      });
}
