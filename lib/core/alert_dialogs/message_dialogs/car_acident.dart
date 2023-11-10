import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:flutter/material.dart';

void carAcident(BuildContext context, String carNumber, VoidCallback sendApi) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 10, ),
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
                    "$carNumber մեքենայի վարորդ, Ձեր մեքենան վթարվել է։",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                  child: Image(
                    image: AssetImage("assets/Message/2.png"),
                    height: 58,
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonFactory.createButton("cta_green", "Ուղարկել", () {
                  Navigator.pop(context);
                  sendApi();
                  success(context, "Հաղորդագրությունն ուղարկված է");
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5)),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      });
}
