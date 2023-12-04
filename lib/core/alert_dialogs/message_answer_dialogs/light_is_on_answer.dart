import 'package:autozone/core/alert_dialogs/report.dart';
import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:flutter/material.dart';

void lightIsOnAnswer(
    BuildContext context,
    String carNumber,
    VoidCallback onClose,
    VoidCallback onApprove,
    int id,
    Function(int) onReport) {
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
                    "$carNumber մեքենայի վարորդ, Ձեր մեքենայի լուսարձակները միացված են։",
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
                  image: AssetImage("assets/Message/5.png"),
                  width: 200,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonFactory.createButton("cta_green", "Շնորհակալություն", () {
                  onApprove();
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5)),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onReport(id);
                    // showReportDialog(context, id, onApprove: () {
                    //   success(context, "Հաղորդագրությունն\nուղարկված է");
                    //   Future.delayed(Duration(seconds: 1), () {
                    //     Navigator.pop(context);
                    //   });
                    // });
                  },
                  child: Container(
                      height: 27,
                      width: 113,
                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/Settings/Report.png"),
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Դժգոհել",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xff164866)),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        );
      });
}
