import 'package:autozone/app/add_tex_date.dart';
import 'package:autozone/app/home/location.dart';
import 'package:autozone/app/payment/payment_status.dart';
import 'package:autozone/core/alert_dialogs/dahk_exception.dart';
import 'package:autozone/core/alert_dialogs/info_tex.dart';
import 'package:autozone/core/alert_dialogs/loading_alert.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/domain/new_auto_repo/iauto.dart';
import 'package:autozone/domain/tex_place_repo/itex_place_repo.dart';
import 'package:autozone/firebase_dynamic_link.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TexPageData {
  final DateTime inspectionDate;
  final String regNumber;
  final String autoNumber;
  final int user_id;
  final bool dahk;

  const TexPageData({
    required this.inspectionDate,
    required this.regNumber,
    required this.autoNumber,
    required this.user_id,
    required this.dahk,
  });
}

class TexPage extends StatefulWidget {
  final TexPageData data;

  const TexPage({required this.data, super.key});

  @override
  State<TexPage> createState() => _TexPageState();
}

class _TexPageState extends State<TexPage> {
  var texPlaceService = ServiceProvider.required<ITexPlaceRepo>();
  var autoService = ServiceProvider.required<IAuto>();

  late DateTime date;

  bool? dahkVal;

  @override
  void initState() {
    setPaymentHistory();

    date = widget.data.inspectionDate;
    super.initState();
  }

  List<dynamic> payInfo = [];

  Future setPaymentHistory() async {
    Dio dio = Dio();

    var body = {
      "userID": widget.data.user_id,
      "car_reg_no": widget.data.autoNumber
    };
    var response = await dio.post(
        "https://autozone.onepay.am/api/v1/techPayment/getOrders",
        data: body,
        options: Options(
          validateStatus: (status) => true,
        ));

    if (response.data["success"] as bool == true) {
      setState(() {
        payInfo = response.data["payInfo"];
      });
    }

    String generatedUrl =
        await FirebaseDynamicLink.createDynamicLink(widget.data);

    print("_____________________");
    print(generatedUrl);
  }

  String getStringFromPayStatus(int status) {
    switch (status) {
      case 2:
        return "Հաստատվել է";
      case 1:
        return "Ստուգվում է";
      case 3:
        return "Մերժվել է";
      default:
        return "";
    }
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
          'Տեխզննում',
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
        child: Column(
          children: <Widget>[
            Container(
              color: const Color(0xffF3F4F6),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: !(widget.data.inspectionDate.day == 1 &&
                            widget.data.inspectionDate.month == 1 &&
                            widget.data.inspectionDate.year == 1970)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Հաջորդ տեխզննում՝ ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xff164866)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 13),
                                child: InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    var phone = prefs.get("phone");

                                    Dio dio = Dio();

                                    var body = {
                                      "techNumber": widget.data.regNumber,
                                      "phoneNumber": "374$phone"
                                    };

                                    loading(context);

                                    var result = await dio.patch(
                                        "https://autozone.onepay.am/api/v1/cars/updateAllCardata",
                                        data: body, options: Options(
                                      validateStatus: (status) {
                                        return true;
                                      },
                                    ));

                                    Navigator.pop(context);

                                    setState(() {
                                      date = DateTime.parse(
                                          result.data["inspection"]);
                                    });
                                  },
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/Settings/Refresh.png"),
                                    height: 13,
                                    width: 13,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Հաջորդ տեխզննում՝ սահմանել",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xff164866)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TexDateChoose(
                                                techNumber:
                                                    widget.data.regNumber,
                                              )));
                                },
                                child: const Image(
                                  image:
                                      AssetImage("assets/Message/Calendar.png"),
                                  width: 18,
                                  height: 18,
                                ),
                              )
                            ],
                          ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    margin: const EdgeInsets.only(
                        top: 15, bottom: 10, right: 10, left: 10),
                    decoration: const BoxDecoration(color: Color(0xffDADADA)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonFactory.createButton("cta_green", "Վճարել", () {
                        if (widget.data.dahk == true) {
                          dahkException(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseLocationPage(
                                        regNumber: widget.data.regNumber,
                                        autoNumber: widget.data.autoNumber,
                                      )));
                        }
                      }, 200, 35,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10)),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            infoTex(context);
                          },
                          child: const Image(
                            image: AssetImage(
                                "assets/Navigation/NavigationBarInfo.png"),
                            width: 24,
                            height: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Գործարքների պատմություն",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xff164866)),
            ),
            const SizedBox(
              height: 20,
            ),
            payInfo.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for (int i = 0; i < payInfo.length; i++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center,
                              color: const Color(0xffF3F4F6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${DateTime.parse(payInfo[i]["created_at"]).day.toString().padLeft(2, '0')}.${DateTime.parse(payInfo[i]["created_at"]).month.toString().padLeft(2, '0')}.${DateTime.parse(payInfo[i]["created_at"]).year} ${DateTime.parse(payInfo[i]["created_at"]).hour.toString().padLeft(2, '0')}:${DateTime.parse(payInfo[i]["created_at"]).minute.toString().padLeft(2, '0')}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Color(0xff164866)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (getStringFromPayStatus(
                                              payInfo[i]["status"]) ==
                                          "Հաստատվել է") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentStatusPage(
                                                        payinfo: payInfo[i],
                                                        stationName: payInfo[i]
                                                                    ["partner"]
                                                                ["translations"]
                                                            ["hy"]["name"],
                                                        stationAddress: payInfo[
                                                                    i]["partner"]
                                                                ["translations"]
                                                            ["hy"]["address"],
                                                        payments: payInfo[i]
                                                                ["items"]
                                                            .map<String>((e) {
                                                          return e["service"]
                                                                  ["name"]
                                                              as String;
                                                        }).toList())));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        getStringFromPayStatus(
                                                    payInfo[i]["status"]) ==
                                                "Հաստատվել է"
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentStatusPage(
                                                                  stationName: payInfo[i]["partner"]
                                                                              ["translations"]
                                                                          ["hy"]
                                                                      ["name"],
                                                                  payinfo:
                                                                      payInfo[
                                                                          i],
                                                                  stationAddress:
                                                                      payInfo[i]
                                                                              ["partner"]["translations"]["hy"][
                                                                          "address"],
                                                                  payments: payInfo[i]
                                                                          ["items"]
                                                                      .map<String>((e) {
                                                                    return e["service"]
                                                                            [
                                                                            "name"]
                                                                        as String;
                                                                  }).toList())));
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             PaymentInfo(
                                                  //               date: payInfo[i]
                                                  //                   ["created_at"],
                                                  //               autoMark: payInfo[i]
                                                  //                       ["request"]
                                                  //                   ["car"],
                                                  //               autoNumber: payInfo[i]
                                                  //                       ["request"]
                                                  //                   ["car_reg_no"],
                                                  //               items: payInfo[i]
                                                  //                       ["items"]
                                                  //                   .map<Map>((item) {
                                                  //                 return {
                                                  //                   "name": item[
                                                  //                           "service"]
                                                  //                       ["name"],
                                                  //                   "value": item[
                                                  //                           "amount"]
                                                  //                       .toString()
                                                  //                 };
                                                  //               }).toList(),
                                                  //               name: payInfo[i]
                                                  //                   ["name"],
                                                  //             )));
                                                },
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/Settings/Check.png"),
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 32,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: getStringFromPayStatus(
                                                          payInfo[i]
                                                              ["status"]) ==
                                                      "Հաստատվել է"
                                                  ? const Color(0xff00B140)
                                                  : getStringFromPayStatus(
                                                              payInfo[i]
                                                                  ["status"]) ==
                                                          "Ստուգվում է"
                                                      ? const Color(0xffFFC700)
                                                      : const Color(0xffFF0000),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            getStringFromPayStatus(
                                                payInfo[i]["status"]),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
