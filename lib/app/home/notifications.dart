import 'package:autozone/app/home/location.dart';
import 'package:autozone/core/alert_dialogs/dahk_exception.dart';
import 'package:autozone/core/alert_dialogs/report.dart';
import 'package:autozone/core/alert_dialogs/station_map.dart';
import 'package:autozone/core/alert_dialogs/success.dart';
import 'package:autozone/core/factory/message_answer_factory.dart';
import 'package:autozone/utils/notification_title_by_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsPage extends StatefulWidget {
  final int userId;
  final dynamic dahk;

  const NotificationsPage(
      {required this.userId, required this.dahk, super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DatabaseReference? database;

  Map<String, Widget> notifications = {};
  Map<String, Widget> paymentDate = {};

  @override
  void initState() {
    super.initState();
    var app = initFirebaseApp();

    Future.wait([app]).then((db) async {
      DatabaseEvent snapshot = await database!.child("messages").once();
      DatabaseEvent insurance_snapshot =
          await database!.child("inspection_due").once();
      DatabaseEvent paymentInfo =
          await database!.child("payment_messages").once();

      try {
        final data = snapshot.snapshot.value is Map
            ? snapshot.snapshot.value as Map<dynamic, dynamic>
            : {};

        final documents = data.values.toList().cast<Map<dynamic, dynamic>>();

        for (int i = 0; i < documents.length; i++) {
          if (documents[i]["issued_user_id"] as int == widget.userId &&
              documents[i]["answer"].toString().isEmpty) {
            setState(() {
              notifications[documents[i]['date']] = notificationTileAnswer(
                  notificationTitleById(documents[i]['issue_type']),
                  notificationBodyById(
                      documents[i]['issue_type'], documents[i]["car_number"]),
                  documents[i]['date'],
                  documents[i]["answer"].toString().isNotEmpty,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  isAnswered: documents[i]["answer"].toString().isNotEmpty,
                  document: documents[i],
                  snapshot: snapshot.snapshot,
                  key: data.keys.toList()[i],
                  answer: documents[i]["answer"]);
            });
          }

          if (documents[i]["issued_user_id"] as int == widget.userId &&
              documents[i]["answer"].toString().isNotEmpty) {
            // print(data.keys.toList()[i]);
            setState(() {
              notifications[documents[i]['date']] = notificationTile(
                  notificationTitleById(documents[i]['issue_type']),
                  notificationBodyById(
                      documents[i]['issue_type'], documents[i]["car_number"]),
                  documents[i]['date'],
                  documents[i]["answer"].toString().isNotEmpty,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  isAnswered: documents[i]["answer"].toString().isNotEmpty,
                  document: documents[i],
                  snapshot: snapshot.snapshot,
                  key: data.keys.toList()[i],
                  answer: documents[i]["answer"]);
            });
          }

          if (documents[i]["requested_user_id"] as int == widget.userId) {
            setState(() {
              notifications[documents[i]['date']] = notificationTile(
                  notificationTitleById(documents[i]['issue_type']),
                  notificationBodyById(
                      documents[i]['issue_type'], documents[i]["car_number"]),
                  documents[i]['date'],
                  documents[i]["answer"].toString().isNotEmpty,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  isAnswered: documents[i]["answer"].toString().isNotEmpty,
                  document: documents[i],
                  snapshot: snapshot.snapshot,
                  key: data.keys.toList()[i],
                  answer: documents[i]["answer"]);
            });
          }

          if (documents[i]["answer"].toString().isNotEmpty &&
              (documents[i]["requested_user_id"] as int == widget.userId ||
                  documents[i]["issued_user_id"] as int == widget.userId)) {
            setState(() {
              notifications[
                  DateTime.parse(documents[i]['date'])
                      .add(const Duration(seconds: 1))
                      .toIso8601String()] = notificationTile(
                  "${documents[i]["car_number"]} վարորդի պատասխանը",
                  documents[i]["answer"],
                  documents[i]['answer_date'],
                  widget.userId == documents[i]["issued_user_id"] as int,

                  // documents[i]["requested_user_id"] as int == widget.userId,
                  isRequested:
                      documents[i]["requested_user_id"] as int == widget.userId,
                  answer: documents[i]["answer"],
                  document: documents[i],
                  forAnswer: true);
            });
          }
        }
      } catch (e) {
        rethrow;
      }

      try {
        final insurance_data = insurance_snapshot.snapshot.value is Map
            ? insurance_snapshot.snapshot.value as Map<dynamic, dynamic>
            : {};
        final instrance_document =
            insurance_data.values.toList().cast<Map<dynamic, dynamic>>();

        for (int i = 0; i < instrance_document.length; i++) {
          if (instrance_document[i]["userId"] as int == widget.userId) {
            setState(() {
              notifications[instrance_document[i]['date']] = buildPaymentTile(
                  instrance_document[i]["car_number"],
                  instrance_document[i]["due_date"],
                  instrance_document[i]["date"],
                  instrance_document[i]["reg_number"],
                  instrance_document[i]);
            });
          }
        }
      } catch (e) {
        rethrow;
      }

      try {
        final payment_data = paymentInfo.snapshot.value is Map
            ? paymentInfo.snapshot.value as Map<dynamic, dynamic>
            : {};
        final payment_document =
            payment_data.values.toList().cast<Map<dynamic, dynamic>>();

        for (int i = 0; i < payment_document.length; i++) {
          if (payment_document[i]["userId"] as int == widget.userId) {
            setState(() {
              DateTime parsed = DateTime.parse(payment_document[i]['date']);

              parsed = parsed.add(const Duration(hours: 4));

              notifications[parsed.toIso8601String()] = buildPaymentStatus(
                  parsed.toIso8601String(),
                  payment_document[i]["body"],
                  payment_document[i].containsKey("longitude"),
                  longitude: payment_document[i].containsKey("longitude")
                      ? double.parse(payment_document[i]["longitude"])
                      : 0.0,
                  latitude: payment_document[i].containsKey("longitude")
                      ? double.parse(payment_document[i]["latitude"])
                      : 0.0,
                  address: payment_document[i]["address"] ?? "",
                  companyName: payment_document[i]["name"] ?? "",
                  titleTile: payment_document[i]["title"] ?? "");
            });
          }
        }
      } catch (e) {
        rethrow;
      }

      List<MapEntry<String, Widget>> entries = notifications.entries.toList();

      var temp = notifications;

      entries.sort(
          (a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key)));

      notifications = Map<String, Widget>.fromEntries(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[100],
            height: 1.0,
          ),
        ),
        title: const Text(
          "Ծանուցումներ",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff164866),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff164866)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
          color: Colors.white,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: notifications.values.toList(),
            ),
          )),
    );
  }

  Future initFirebaseApp() async {
    setState(() {
      database = FirebaseDatabase.instance.ref();
    });
  }

  Widget buildPaymentStatus(String date, String title, bool isSuccess,
      {double? longitude,
      double? latitude,
      String? address,
      String? companyName, 
      required String titleTile}) {
    DateTime parsedDate = DateTime.parse(date);

    DateTime today = DateTime.now();

    bool isToday = parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day;

    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xffF5F5F5),
          width: 1.0,
        ),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F4),
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Image(
                  image: AssetImage(
                    "assets/Settings/Req.png",
                  ),
                  width: 15,
                  height: 15,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                titleTile,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xff164866),
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xff164866),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              isSuccess
                  ? InkWell(
                      onTap: () {
                        showMapDialog(context, latitude ?? 0.0,
                            longitude ?? 0.0, address ?? "", companyName ?? "");
                      },
                      child: Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                            color: const Color(0xff00611E),
                            borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Քարտեզ",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    )
                  : Container(),
              Text(
                isToday
                    ? "Այսօր ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}"
                    : "${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month}.${parsedDate.year} ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xff164866),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildPaymentTile(String carNumber, String dueDate, String date,
      String regNumber, dynamic document) {
    DateTime parsedDate = DateTime.parse(dueDate);
    DateTime parsedDateRec = DateTime.parse(date);

    DateTime today = DateTime.now();


    bool isToday = parsedDateRec.year == today.year &&
        parsedDateRec.month == today.month &&
        parsedDateRec.day == today.day;

    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffF5F5F5),
        width: 1.0,
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Image(
                      image: AssetImage(
                        "assets/Settings/Req.png",
                      ),
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Հիշեցում",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xff164866),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "$carNumber մեքենայի տեխզննման ժամկետն ավարտվում է ${parsedDate.day}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}թ.-ին:",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xff164866),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  height: 35,
                  child: InkWell(
                    onTap: () {
                      if (widget.dahk[document["car_number"]]) {
                        dahkException(context);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseLocationPage(
                                    autoNumber: carNumber,
                                    regNumber: regNumber)));
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff00611E),
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      child: const Text(
                        "Վճարել",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Text(
                  isToday ? "Այսօր ${parsedDateRec.hour.toString().padLeft(2, '0')}:${parsedDateRec.minute.toString().padLeft(2, '0')}":
                  "${parsedDateRec.day.toString().padLeft(2, '0')}.${parsedDateRec.month}.${parsedDateRec.year} ${parsedDateRec.hour.toString().padLeft(2, '0')}:${parsedDateRec.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xff164866)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool getTheRec(bool answer, int recId, int reqId) {
    if (answer) {
      if (reqId == widget.userId) {
        return true;
      }

      return false;
    }

    if (reqId == widget.userId) {
      return false;
    }

    return true;
  }

  Widget notificationTile(String title, String body, String date, bool seen,
      {bool isAnswered = true,
      required bool isRequested,
      dynamic document,
      dynamic snapshot,
      dynamic key,
      dynamic answer,
      bool forAnswer = false}) {
    DateTime prasedData = DateTime.parse(date);

    DateTime today = DateTime.now();

    String notificationDate = "";

    if (prasedData.day == today.day &&
        prasedData.month == today.month &&
        prasedData.year == today.year) {
      notificationDate =
          "Այսօր ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    } else {
      notificationDate =
          "${prasedData.day.toString().padLeft(2, '0')}.${prasedData.month}.${prasedData.year}"
          " ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    }

    int reqId = document["requested_user_id"] as int;
    int recId = document["issued_user_id"] as int;

    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffF5F5F5),
        width: 1.0,
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: getTheRec(forAnswer, recId, reqId)
                        ? const Image(
                            image: AssetImage("assets/Settings/Req.png"),
                            width: 15,
                            height: 15,
                          )
                        : const Image(
                            image: AssetImage(
                              "assets/Settings/Rec.png",
                            ),
                            width: 15,
                            height: 15,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xff164866),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  showReport(context, reqId, recId, document["date"],
                      document["seenDate"], widget.userId);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffF2F2F4),
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Image(
                    image: const AssetImage("assets/Settings/CheckIcon.png"),
                    width: 20,
                    height: 20,
                    color: document["active"] as bool
                        ? const Color(0xff164866)
                        : const Color(0xff164866),
                  ),
                ),
              )
            ],
          ),
          Text(
            body,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xff164866),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: document["issue_type"] == "car_number" &&
                      document["requested_user_id"] == widget.userId &&
                      title.contains("պատասխանը"),
                  child: InkWell(
                    onTap: () async {
                      String phoneNumber = document["phoneNumber"];
                      Uri url = Uri.parse('tel:$phoneNumber');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Container(
                      width: 150,
                      height: 35,
                      decoration: BoxDecoration(
                          color: const Color(0xff00611E),
                          borderRadius: BorderRadius.circular(25)),
                      alignment: Alignment.center,
                      child: const Text(
                        "Զանգահարել",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Text(
                  notificationDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xff164866),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget notificationTileAnswer(
      String title, String body, String date, bool seen,
      {bool isAnswered = true,
      required bool isRequested,
      dynamic document,
      dynamic snapshot,
      dynamic key,
      dynamic answer,
      bool forAnswer = false}) {
    DateTime prasedData = DateTime.parse(date);

    DateTime today = DateTime.now();

    String notificationDate = "";

    if (prasedData.day == today.day &&
        prasedData.month == today.month &&
        prasedData.year == today.year) {
      notificationDate =
          "Այսօր ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    } else {
      notificationDate =
          "${prasedData.day.toString().padLeft(2, '0')}.${prasedData.month}.${prasedData.year}"
          " ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}";
    }

    int reqId = document["requested_user_id"] as int;
    int recId = document["issued_user_id"] as int;

    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xffF5F5F5),
        width: 1.0,
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F4),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: getTheRec(forAnswer, recId, reqId)
                        ? const Image(
                            image: AssetImage("assets/Settings/Req.png"),
                            width: 15,
                            height: 15,
                          )
                        : const Image(
                            image: AssetImage(
                              "assets/Settings/Rec.png",
                            ),
                            width: 15,
                            height: 15,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xff164866),
                    ),
                  ),
                ],
              ),
              Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F4),
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Image(
                  image: const AssetImage("assets/Settings/CheckIcon.png"),
                  width: 20,
                  height: 20,
                  color: !(document["active"] as bool)
                      ? const Color(0xff164866)
                      : const Color(0xff164866),
                ),
              )
            ],
          ),
          Text(
            body,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xff164866),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    MessageAnswerFactory.getMessage(
                        snapshot: snapshot,
                        key: key,
                        id: document["issued_user_id"] as int,
                        type: document["issue_type"] as String,
                        context: context,
                        number: document["car_number"],
                        onReport: (id) {
                          showReportDialog(context, id, onApprove: () {
                            success(context, "Հաղորդագրությունն\nուղարկված է");
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          });
                        },
                        onClose: () {
                          Navigator.pop(context);

                          snapshot.ref
                              .update({"$key/answer": "Չեմ կարող մոտենալ"});
                          snapshot.ref.update(
                              {"$key/answer_date": DateTime.now().toString()});

                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsPage(
                                        userId: widget.userId,
                                        dahk: widget.dahk,
                                      )));

                          success(context, "Հաղորդագրությունն\nուղարկված է");
                        },
                        onApprove: () {
                          Navigator.pop(context);

                          if (document["issue_type"] == "car_number") {
                            String answer =
                                "Խնդրում եմ զանգահարել ${document["phoneNumber"]} հեռախոսահամարին:";

                            snapshot.ref.update({"$key/answer": answer});
                            snapshot.ref.update({
                              "$key/answer_date": DateTime.now().toString()
                            });
                          } else {
                            // snapshot.ref
                            //     .update({"$key/answer": "Շուտով կմոտենամ"});
                            // snapshot.ref.update({
                            //   "$key/answer_date": DateTime.now().toString()
                            // });

                            if (document["issue_type"] == "open_door" ||
                                document["issue_type"] == "light_is_on") {
                              snapshot.ref.update({
                                "$key/answer": "Շնորհակալություն",
                                "$key/answer_date": DateTime.now().toString()
                              });

                              sendMessage(document["requested_user_id"] as int,
                                  "AutoZone", "Շնորհակալություն");
                            } else {
                              snapshot.ref.update({
                                "$key/answer": "Շուտով կմոտենամ",
                                "$key/answer_date": DateTime.now().toString()
                              });

                              sendMessage(document["requested_user_id"] as int,
                                  "AutoZone", "Շուտով կմոտենամ");
                            }
                          }
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsPage(
                                      userId: widget.userId,
                                      dahk: widget.dahk)));

                          success(context, "Հաղորդագրությունն\nուղարկված է");
                        },
                        onNumberApprove: (String number) {
                          Navigator.pop(context);

                          if (document["issue_type"] == "car_number") {
                            String answer =
                                "Խնդրում եմ զանգահարել $number հեռախոսահամարին:";

                            snapshot.ref.update({"$key/answer": answer});
                            snapshot.ref.update({
                              "$key/answer_date": DateTime.now().toString()
                            });
                          } else {
                            snapshot.ref
                                .update({"$key/answer": "Շուտով կմոտենամ"});
                            snapshot.ref.update({
                              "$key/answer_date": DateTime.now().toString()
                            });
                          }
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsPage(
                                      userId: widget.userId,
                                      dahk: widget.dahk)));

                          success(context, "Հաղորդագրությունն\nուղարկված է");
                        },
                        phoneNumber: document["phoneNumber"]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                            color: const Color(0xff00611E),
                            borderRadius: BorderRadius.circular(25)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Պատասխանել",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          // showReport(context, 1, "${prasedData.day.toString().padLeft(2, '0')}.${prasedData.month}.${prasedData.year} ${prasedData.hour.toString().padLeft(2, '0')}:${prasedData.minute.toString().padLeft(2, '0')}");
                          showReportDialog(
                              context, document["requested_user_id"] as int,
                              onApprove: () {
                            success(context, "Հաղորդագրությունն\nուղարկված է");
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: const Image(
                          image: AssetImage("assets/Message/NotReport.png"),
                          width: 18,
                          height: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  notificationDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xff164866),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
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

void showReport(BuildContext context, int requestId, int issueId, String date,
    String answerDate, int userId) {
  double height = 10;

  String answeFormatedDate = "";

  DateTime time = DateTime.parse(date);
  if (answerDate != "") {
    DateTime answDate = DateTime.parse(answerDate);
    answeFormatedDate =
        "${answDate.day.toString().padLeft(2, "0")}.${answDate.month.toString().padLeft(2, "0")} ${answDate.hour.toString().padLeft(2, "0")}:${answDate.minute.toString().padLeft(2, "0")}";
  }

  String formatedDate =
      "${time.day.toString().padLeft(2, "0")}.${time.month.toString().padLeft(2, "0")} ${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}";

  String who = "";
  int whoseId = userId;

  if (userId == issueId) {
    who = "Ուղարկողի";
    whoseId = requestId;
  } else {
    who = "Ստացողի";
    whoseId = issueId;
  }

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/Person.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "$who ID $whoseId",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.transparent),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffF2F2F4)),
                        child: const Image(
                          image: AssetImage("assets/Message/Request.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Ծանուցումը ստացվել է",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xff164866)),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      formatedDate,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xff164866)),
                    ),
                  )
                ],
              ),
              answeFormatedDate != ""
                  ? SizedBox(
                      height: height,
                    )
                  : Container(),
              answeFormatedDate != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xffF2F2F4)),
                              child: const Image(
                                image: AssetImage("assets/Message/SeenReq.png"),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Ծանուցումը դիտվել է",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Color(0xff164866)),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            answeFormatedDate,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Color(0xff164866)),
                          ),
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      });
}
