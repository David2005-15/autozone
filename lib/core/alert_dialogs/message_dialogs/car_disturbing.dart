import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:flutter/material.dart';

void carDisturbing(
    BuildContext context, String carNumber, VoidCallback sendApi) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color(0xffF3F4F6),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5))),
                  child: Text(
                    "$carNumber մեքենայի վարորդ, Ձեր մեքենան փակել է իմ մեքենայի ճանապարհը։",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Image(
                  image: AssetImage("assets/Message/1.png"),
                  height: 150,
                  width: 200,
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonFactory.createButton("cta_green", "Ուղարկել", () {
                  Navigator.pop(context);
                  sendApi();
                  // success(context, "Հաղորդագրությունն\nուղարկված է");
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
