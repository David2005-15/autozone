import 'package:autozone/core/alert_dialogs/error_alert.dart';
import 'package:autozone/core/alert_dialogs/fail.dart';
import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/button_factory.dart';
import 'package:autozone/core/factory/message_factory.dart';
import 'package:autozone/core/widgets/inputs/input_box_without_suffix.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SearchCarPage extends StatefulWidget {
  final int userId;
  final List<String> ownCars;

  const SearchCarPage({super.key, required this.userId, required this.ownCars});

  @override
  State<SearchCarPage> createState() => SearchCarPageState();
}

class SearchCarPageState extends State<SearchCarPage> {
  bool isClickedSearch = false;
  bool isIssueListClicked = false;
  bool isError = false;

  int requestedUserId = 0;
  String deviceToken = "";

  String mark = "";

  late DatabaseReference database;
  late FirebaseMessaging messaging;

  var autoNumberController = TextEditingController();

  String phoneNumber = "";

  void getPhoneNumber() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      phoneNumber = prefs.getString("phone")!;
    });
  }

  void resetState() {
    setState(() {
      isClickedSearch = false;
      isIssueListClicked = false;
      isError = false;
      autoNumberController.text = "";
    });
  }

  void setTodayDate() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("today", DateTime.now().toIso8601String());
  }

  int count = 0;

  void setTotalCount() async {
    Dio dio = Dio();

    var result =
        await dio.get("https://autozone.onepay.am/api/v1/cars/getCount");

    setState(() {
      count = result.data["count"] as int;
    });
  }

  @override
  void initState() {
    super.initState();
    setTotalCount();
    setTodayDate();
    var database = initFirebaseApp();
    var messaging = initFirebaseMessaging();
    getPhoneNumber();

    Future.wait([database, messaging]);
  }

  @override
  Widget build(BuildContext context) {
    return isClickedSearch
        ? searchCar(context)
        : isIssueListClicked
            ? getIssueListInColumn()
            : isError
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xffFCFCFC),
                    margin: const EdgeInsets.only(right: 5, left: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "${autoNumberController.text} մեքենայի տվյալները դեռևս անհասանելի են",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xff164866)),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    // padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: const Image(
                            image: AssetImage("assets/ParkingSign.png"),
                            width: 276,
                            height: 104,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: const Text(
                            "Փնտրիր մեքենան և վարորդին ուղարկիր ծանուցում",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xff164866)),
                          ),
                        ),
                        const SizedBox(height: 31),
                        ButtonFactory.createButton(
                          "cta_green",
                          "Որոնել",
                          () {
                            setState(() {
                              isClickedSearch = true;
                            });
                          },
                          253,
                          42,
                        )
                      ],
                    ),
                  );
  }

  Widget searchCar(context) {
    return StatefulBuilder(builder: (context, state) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffFCFCFC),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 157,
              height: 37,
              margin: const EdgeInsets.only(top: 32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xffF2F2F4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage("assets/Message/SearchPageAuto.png"),
                    width: 57,
                    height: 18,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 5, left: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff164866)),
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff164866)),
                  )
                ],
              ),
            ),
            Column(
              children: [
                InputBoxWithoutSuffix(
                    isSearchable: true,
                    label: "00XX000",
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      LengthLimitingTextInputFormatter(7)
                    ],
                    controller: autoNumberController,
                    margin: const EdgeInsets.only(left: 63, right: 63),
                    onChanged: (val) {
                      state(() {
                        autoNumberController.text =
                            autoNumberController.text.toUpperCase();
                      });
                    }),
                ButtonFactory.createButton(
                  "cta_green",
                  "Որոնել",
                  !widget.ownCars.contains(autoNumberController.text) &&
                          autoNumberController.text.isNotEmpty
                      ? () async {
                          Dio dio = Dio();

                          var result = await dio.get(
                              "https://autozone.onepay.am/api/v1/cars/getUserByCarNumber/${autoNumberController.text}",
                              options: Options(
                            validateStatus: (status) {
                              return true;
                            },
                          ));

                          if (result.data["success"] as bool == false) {
                            setState(() {
                              isError = true;
                              isClickedSearch = false;
                              isIssueListClicked = false;
                            });

                            Future.delayed(const Duration(seconds: 2), () {
                              resetState();
                            });
                          } else {
                            setState(() {
                              isClickedSearch = false;
                              isIssueListClicked = true;
                              requestedUserId = int.parse(
                                  result.data["User"]["id"].toString());

                              mark = result.data["User"]["Cars"][0]["carMark"]
                                  .toString()
                                  .split(" ")[0];

                              deviceToken =
                                  result.data["User"]["deviceToken"].toString();
                            });
                          }
                        }
                      : null,
                  double.infinity,
                  42,
                  margin: const EdgeInsets.only(left: 63, right: 63, top: 20),
                ),
              ],
            ),
            Container()
          ],
        ),
      );
    });
  }

  Widget getIssueListInColumn() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      color: const Color(0xffFCFCFC),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: const Color(0xffF2F2F4),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  mark,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xff164866)),
                ),
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff164866)),
                ),
                Text(
                  autoNumberController.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xff164866)),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      issueContainer("assets/ParkingSign.png", "Խանգարում է",
                          () {
                        MessageFactory.getMessage(
                            "disturb", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "disturb",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Խանգարում է",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենան փակել է իմ մեքենայի ճանապարհը։");
                        });
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      issueContainer(
                          "assets/Message/OpenDoor.png", "Բաց է պատուհանը", () {
                        MessageFactory.getMessage(
                            "open_door", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "open_door",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Բաց է պատուհանը",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենայի պատուհանը բաց է։");
                        });
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      issueContainer(
                          "assets/Message/CarAccident.png", "Վթարվել է", () {
                        MessageFactory.getMessage(
                            "acident", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "acident",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });

                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Վթարվել է",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենան վթարվել է։");
                        });
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      issueContainer(
                          "assets/Message/LightIsOn.png", "Միացված են", () {
                        MessageFactory.getMessage(
                            "light_is_on", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "light_is_on",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });
                          await sendMessage(requestedUserId, "Միացված են",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենայի լուսարձակները միացված են։");
                        });
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      issueContainer("assets/Message/3.png", "Էվակուացնում են",
                          () {
                        MessageFactory.getMessage(
                            "evacuation", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "evacuation",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });
                          await sendMessage(requestedUserId, "Էվակուացնում են",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենան էվակուացնում են։");
                        });
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      issueContainer("assets/Message/9.png", "Գտել եմ", () {
                        MessageFactory.getMessage(
                            "car_number", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "car_number",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Գտել եմ",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, գտել եմ Ձեր մեքենայի համարանիշը։");
                        });
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      issueContainer("assets/Message/6.png", "Փակել է", () {
                        MessageFactory.getMessage("closed_enterance", context,
                            autoNumberController.text, () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }
                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "closed_enterance",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });
                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Փակել է",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենան փակել է իմ մեքենայի ճանապարհը։");
                        });
                      }),
                      const SizedBox(
                        width: 5,
                      ),
                      issueContainer("assets/Message/7.png", "Վնասել են", () {
                        MessageFactory.getMessage(
                            "car_hit", context, autoNumberController.text,
                            () async {
                          var prefs = await SharedPreferences.getInstance();

                          int? count;

                          if (prefs.getInt("count") == null) {
                            count = 0;
                            prefs.setInt("count", count);
                          } else {
                            count = prefs.getInt("count");
                          }

                          if (count == 2) {
                            fail(context,
                                "Դուք կարող եք օրեկան ուղարկել առավելագույնը 2 ծանուցում");
                            return;
                          }

                          await database
                              .child("messages")
                              .child("message${const Uuid().v4()}")
                              .set({
                            "requested_user_id": widget.userId,
                            "issued_user_id": requestedUserId,
                            "issue_type": "car_hit",
                            "car_number": autoNumberController.text,
                            "answer": "",
                            "date": DateTime.now().toString(),
                            "answer_date": "",
                            "phoneNumber": phoneNumber,
                            "active": true,
                            "seenDate": ""
                          });

                          success(context, "Հաղորդագրությունն\nուղարկված է");

                          prefs.setInt("count", count! + 1);

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            resetState();
                          });

                          await sendMessage(requestedUserId, "Վնասել են",
                              "${autoNumberController.text.toUpperCase()} մեքենայի վարորդ, Ձեր մեքենան վնասել են։");
                        });
                      })
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget issueContainer(String path, String title, VoidCallback onTap) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () async {
          onTap();
        },
        child: Container(
          width: 175,
          height: 110,
          decoration: BoxDecoration(
            color: const Color(0xffF3F4F6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                height: 70,
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Image(
                  image: AssetImage(path),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Container(
                color: const Color(0xffF3F4F6),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff164866)),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future initFirebaseApp() async {
    setState(() {
      database = FirebaseDatabase.instance.ref();
    });
  }

  Future initFirebaseMessaging() async {
    setState(() {
      messaging = FirebaseMessaging.instance;
    });
  }

  Future sendMessage(int recieverId, String title, String body) async {
    var prefs = await SharedPreferences.getInstance();
    var message = {"receiverId": recieverId, "title": title, "body": body};

    Dio dio = Dio();

    await dio.post(
      "https://autozone.onepay.am/api/v1/notifications/send",
      data: message,
      options: Options(
        headers: {"Authorization": "Bearer ${prefs.getString("token")}"},
        validateStatus: (status) {
          return true;
        },
      ),
    );
  }
}
