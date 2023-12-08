import 'package:autozone/core/alert_dialogs/fail.dart';
import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TexPay extends StatefulWidget {
  final String insuranceName;
  final String workingHours;
  final String address;
  final String regNumber;
  final String autoNumber;
  final int station;

  const TexPay(
      {super.key,
      required this.insuranceName,
      required this.workingHours,
      required this.address,
      required this.autoNumber,
      required this.regNumber,
      required this.station});

  @override
  State<TexPay> createState() => _TexPay();
}

class _TexPay extends State<TexPay> {
  @override
  void initState() {
    setServiceToPay();
    super.initState();
  }

  List<dynamic> serviceToPay = [];

  void setServiceToPay() async {
    Dio dio = Dio();

    var body = {"techNumber": widget.regNumber};

    var response = await dio.post(
        "https://autozone.onepay.am/api/v1/techPayment/getServicesForPay",
        data: body, options: Options(validateStatus: (status) {
      return true;
    }));

    if (response.data["success"] as bool == true) {
      setState(() {
        serviceToPay = response.data["services"];

        if (serviceToPay[0]["amounts"]["data"][0]["amount"] <= 0) {
          isElectroCar = true;
        }
        selectedSwitches = List.filled(serviceToPay.length, true);

        serviceToPay.forEach((element) async {
          payServicesId.add(element["id"]);
        });

        int index = 0;

        serviceToPay.forEach((element) {
          element["amounts"]["data"].forEach((e) {
            amount += int.parse(e["amount"].toString());

            selectedSwitches[index] = false;

            currentAmount = amount;
          });

          index += 1;
        });

        texSum += int.parse(
            serviceToPay[1]["amounts"]["data"][0]["amount"].toString());
      });
    }
  }

  List<bool> selectedSwitches = [];

  List<int> payServicesId = [];

  bool isElectroCar = false;

  int amount = 0;

  int currentAmount = 0;

  var haveAlreadyClicked = false;

  bool coSwitch = true;
  bool texPaymentSwitch = true;

  int coSum = 300;
  int texSum = 300;

  @override
  Widget build(BuildContext context) {
    coSum = 300;

    if (isElectroCar) {
      coSwitch = false;
    }

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
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
          'Տեխզնման վճարում',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffFCFCFC),
        child: serviceToPay.isNotEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            buildTaxPayment(widget.insuranceName,
                                widget.address, widget.workingHours),
                            buildAutoNumber(
                                widget.autoNumber,
                                serviceToPay[0]["extra_name"]
                                    .toString()
                                    .isNotEmpty,
                                serviceToPay[0]["extra_name"]),
                            buildPaySectionsCo(
                                serviceToPay[0]["info"]["name"].toString(),
                                serviceToPay[0]["amounts"]["data"]
                                    .take(serviceToPay[0]["amounts"]["data"]
                                            .length -
                                        1)
                                    .map<String>((e) {
                                  // return (serviceToPay[0]["info"]["name"] + e["extra_label"] ?? "").toString();
                                  if (e["extra_label"] == null) {
                                    return (serviceToPay[0]["info"]["name"])
                                        .toString();
                                  }

                                  return (serviceToPay[0]["info"]["name"] +
                                              e["extra_label"] ??
                                          "")
                                      .toString();
                                }).toList(),
                                serviceToPay[0]["amounts"]["data"]
                                    .take(serviceToPay[0]["amounts"]["data"]
                                            .length -
                                        1)
                                    .map<String>((e) {
                                  if (int.parse(e["amount"].toString()) >= 0) {
                                    coSum += int.parse(e["amount"].toString());
                                  }
                                  // coSum += int.parse(e["amount"].toString());

                                  return e["amount"].toString();
                                }).toList(),
                                serviceToPay[0]["amounts"]["data"]
                                    .last["amount"]
                                    .toString(),
                                coSwitch, (val) {
                              setState(() {
                                if (serviceToPay[0]["amounts"]["data"][0]
                                        ["amount"] >
                                    0) {
                                  coSwitch = val!;

                                  if (!coSwitch) {
                                    currentAmount -= coSum;
                                    payServicesId.remove(serviceToPay[0]["id"]);
                                  } else {
                                    currentAmount += coSum;
                                    payServicesId.add(serviceToPay[0]["id"]);
                                  }

                                  if (coSwitch == false &&
                                      texPaymentSwitch == false) {
                                    texPaymentSwitch = true;
                                    currentAmount += texSum;
                                    payServicesId.add(serviceToPay[1]["id"]);
                                  }
                                } else {
                                  fail(context,
                                      "Էլեկտրական կամ հիբրիդային շարժիչով մեքենաները ազատված են բնապահպանական հարկի վճարից։");
                                }
                                // coSwitch = val!;

                                // if (!coSwitch) {
                                //   currentAmount -= coSum;
                                //   payServicesId.remove(serviceToPay[0]["id"]);
                                // } else {
                                //   currentAmount += coSum;
                                //   payServicesId.add(serviceToPay[0]["id"]);
                                // }

                                // if (coSwitch == false &&
                                //     texPaymentSwitch == false) {
                                //   texPaymentSwitch = true;
                                //   currentAmount += texSum;
                                //   payServicesId.add(serviceToPay[1]["id"]);
                                // }
                              });
                            }),
                            buildPaySections(
                                serviceToPay[1]["info"]["name"].toString(),
                                serviceToPay[1]["amounts"]["data"][0]["amount"]
                                    .toString(),
                                serviceToPay[1]["amounts"]["data"][1]["amount"]
                                    .toString(),
                                texPaymentSwitch, (val) {
                              setState(() {
                                if (!isElectroCar) {
                                  texPaymentSwitch = val!;

                                  if (!texPaymentSwitch) {
                                    currentAmount -= texSum;
                                    payServicesId.remove(serviceToPay[1]["id"]);
                                  } else {
                                    currentAmount += texSum;
                                    payServicesId.add(serviceToPay[1]["id"]);
                                  }

                                  if (coSwitch == false &&
                                      texPaymentSwitch == false) {
                                    coSwitch = true;
                                    currentAmount += coSum;
                                    payServicesId.add(serviceToPay[0]["id"]);
                                  }
                                }
                              });
                            }),
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              color: const Color(0XFFF3F4F6),
                              alignment: Alignment.center,
                              child: Text(
                                "$currentAmount դր․",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff164866),
                                    fontSize: 25),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    ButtonFactory.createButton("cta_green", "Վճարել", () async {
                      if (haveAlreadyClicked) {
                        return;
                      }

                      setState(() {
                        haveAlreadyClicked = true;
                      });

                      Dio dio = Dio();

                      var body = {
                        "techNumber": widget.regNumber,
                        "station": widget.station,
                        "services": payServicesId
                      };

                      loading(context);

                      var response = await dio.post(
                          "https://autozone.onepay.am/api/v1/techPayment/getPaymentURL",
                          data: body,
                          options: Options(validateStatus: (status) {
                        return true;
                      }));

                      setState(() {
                        haveAlreadyClicked = true;
                      });

                      try {
                        if (await canLaunchUrl(
                            Uri.parse(response.data["order"]["formUrl"]))) {
                          await launchUrl(
                              Uri.parse(response.data["order"]["formUrl"]));
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() {
                          haveAlreadyClicked = true;
                        });

                        Navigator.pop(context);

                        // ignore: use_build_context_synchronously
                        fail(context, response.data["warning"]);
                      }
                    }, double.infinity, 48,
                        margin: const EdgeInsets.only(
                            right: 25, left: 25, top: 15, bottom: 10))
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildPaySections(String payReason, String reasonAmount,
      String middleAmount, bool isSelected, Function(bool?) onChanged) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: double.infinity,
            color: const Color(0XFFF3F4F6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    payReason,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Switch(
                    value: isSelected,
                    onChanged: onChanged,
                    activeColor: const Color(0xff007200),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 90,
            width: double.infinity,
            color: const Color(0xffF3F4F6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        payReason,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      ),
                      Text(
                        "$reasonAmount դր․",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Միջնորդավճար",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      ),
                      Text(
                        "$middleAmount դր․",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaySectionsCo(
      String reason,
      List<String> payReason,
      List<String> reasonAmount,
      String middleAmount,
      bool isSelected,
      Function(bool?) onChanged) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: double.infinity,
            color: const Color(0XFFF3F4F6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    reason,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff164866),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Switch(
                    value: isSelected,
                    onChanged: onChanged,
                    activeColor: const Color(0xff007200),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 90,
            width: double.infinity,
            color: const Color(0xffF3F4F6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < payReason.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, top: 5, bottom: 5, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          payReason[i],
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff164866)),
                        ),
                        Text(
                          "${reasonAmount[i]} դր․",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xff164866)),
                        )
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Միջնորդավճար",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      ),
                      Text(
                        "$middleAmount դր․",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Color(0xff164866)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAutoNumber(String number, bool isTwoYear, String? year) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 50,
      alignment: Alignment.center,
      color: const Color(0xffF3F4F6),
      child: Text(
        isTwoYear ? "$number (տեխզննում 2 տարով)" : number,
        style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xff164866),
            fontSize: 15),
      ),
    );
  }

  Widget buildTaxPayment(String name, String address, String workingTime) {
    return Container(
      width: double.infinity,
      color: const Color(0xffF3F4F6),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.only(bottom: 7),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xff164866),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Image(
                        image: AssetImage("assets/Settings/Edit.png"),
                        width: 21,
                        height: 21),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.only(right: 5, left: 5),
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(address,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff164866),
                      )),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(workingTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xff164866),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
