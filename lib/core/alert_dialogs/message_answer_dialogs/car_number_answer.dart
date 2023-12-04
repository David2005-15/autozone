import 'package:autozone/core/factory/button_factory.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void carNumberAnswer(
    BuildContext context,
    String carNumber,
    VoidCallback onClose,
    Function(String) onApprove,
    String phoneNumber,
    int id,
    DataSnapshot snapshot,
    String key,
    Function(int) onReport) async {
  bool needToChange = false;
  var numberController = TextEditingController();

  var focusNode = FocusNode();

  var prefs = await SharedPreferences.getInstance();

  var phone = prefs.getString("phone") ?? "";

  if (phone[0] != "0" && phone.length != 9) {
    phone = "0$phone";
  }

  phone = phone.substring(1);

  Future.delayed(Duration.zero, () {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
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
                        "$carNumber մեքենայի վարորդ, գտել եմ Ձեր մեքենայի համարանիշը։",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xff164866),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0, left: 8),
                      child: Image(
                        image: AssetImage("assets/Message/9.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonFactory.createButton(
                        "cta_green",
                        "Տրամադրել հեռախոսահամար",
                        !needToChange
                            ? () {
                                snapshot.ref
                                    .update({"$key/phoneNumber": "0$phone"});
                                onApprove(phone);
                              }
                            : null,
                        double.infinity,
                        42,
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 5)),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        needToChange == false
                            ? Text(
                                phone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color(0xff164866),
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 30,
                                child: TextField(
                                  controller: numberController,
                                  onChanged: (val) {
                                    state(() {
                                      phone = val;
                                    });
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(9)
                                  ],
                                  keyboardType: TextInputType.phone,
                                  focusNode: focusNode,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color(0xff164866),
                                  ),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            state(() {
                              needToChange = !needToChange;

                              if (needToChange) {
                                focusNode.requestFocus();
                              } else {
                                focusNode.unfocus();

                                if (numberController.text != "0$phone" ||
                                    numberController.text != "") {
                                  phone = numberController.text;
                                }
                              }
                            });
                          },
                          child: !needToChange
                              ? const Image(
                                  image: AssetImage("assets/Settings/Edit.png"),
                                  width: 22,
                                  height: 22,
                                )
                              : const Image(
                                  image: AssetImage(
                                      "assets/Settings/CheckIcon.png"),
                                  width: 22,
                                  height: 22,
                                  color: Color(0xff164866),
                                ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Ձեր հեռախոսահամարը կուղարկվի հաղորդագրությունն ուղարկողին։",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xff164866),
                      ),
                    ),
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
        });
  });
}
