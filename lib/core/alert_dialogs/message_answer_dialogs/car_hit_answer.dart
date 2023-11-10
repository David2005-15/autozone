import 'package:autozone/core/alert_dialogs/report.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:flutter/material.dart';

void carHitAnswer(BuildContext context, String carNumber, VoidCallback onClose,
    VoidCallback onApprove, int id) {
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
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$carNumber մեքենայի վարորդ, Ձեր մեքենան վնասել են։",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                const Image(
                  image: AssetImage("assets/Message/CarHit.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonFactory.createButton("cta_green", "Շուտով կմոտենամ", () {
                  onApprove();
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5)),
                ButtonFactory.createButton("cta_red", "Չեմ կարող մոտենալ", () {
                  onClose();
                }, double.infinity, 42,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 5)),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showReportDialog(context, id);
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